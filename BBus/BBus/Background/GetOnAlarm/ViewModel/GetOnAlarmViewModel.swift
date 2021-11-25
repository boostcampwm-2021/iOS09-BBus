//
//  GetOnAlarmViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation
import Combine

final class GetOnAlarmViewModel {

    let usecase: GetOnAlarmUsecase
    private(set) var getOnAlarmStatus: GetOnAlarmStatus
    private var cancellables: Set<AnyCancellable>
    @Published private(set) var busApproachStatus: BusApproachStatus?
    private(set) var message: String?
    @Published private(set) var networkErrorMessage: (title: String, body: String)?

    init(usecase: GetOnAlarmUsecase, currentStatus: GetOnAlarmStatus) {
        self.usecase = usecase
        self.getOnAlarmStatus = currentStatus
        self.message = nil
        self.networkErrorMessage = nil
        self.cancellables = []
        self.busApproachStatus = nil
        self.execute()
        self.configureObserver()
    }

    private func configureObserver() {
        NotificationCenter.default.addObserver(forName: .fifteenSecondsPassed, object: nil, queue: .main) { [weak self] _ in
            self?.fetch()
        }
    }

    private func execute() {
        self.bindBusPosition()
        self.bindNetworkErrorMessage()
    }
    
    func bindBusPosition() {
        self.usecase.$busPosition
            .receive(on: GetOnAlarmUsecase.queue)
            .sink { [weak self] position in
                guard let self = self,
                      let position = position,
                      let stationOrd = Int(position.stationOrd) else { return }

                if let status = BusApproachCheckUsecase().execute(currentOrd: stationOrd,
                                                                  beforeOrd: self.getOnAlarmStatus.currentBusOrd ?? stationOrd,
                                                                  targetOrd: self.getOnAlarmStatus.targetOrd) {
                    self.makeMessage(with: status)
                    self.busApproachStatus = status
                }
                self.getOnAlarmStatus = self.getOnAlarmStatus.withCurrentBusOrd(stationOrd)
            }
            .store(in: &self.cancellables)
    }
    
    func bindNetworkErrorMessage() {
        self.usecase.$networkError
            .receive(on: GetOnAlarmUsecase.queue)
            .sink(receiveValue: { [weak self] error in
                guard let _ = error else { return }
                self?.networkErrorMessage = ("승차 알람", "네트워크 에러가 발생하여 알람이 취소됩니다.")
            })
            .store(in: &self.cancellables)
    }

    func fetch() {
        self.usecase.fetch(withVehId: "\(self.getOnAlarmStatus.vehicleId)")
    }

    private func makeMessage(with status: BusApproachStatus) {
        self.message = "\(self.getOnAlarmStatus.busName)번 버스가 \(status.rawValue)번째 전 정류장에 도착하였습니다."
    }
}
