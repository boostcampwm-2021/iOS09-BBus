//
//  GetOnAlarmViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation
import Combine

class GetOnAlarmViewModel {

    let usecase: GetOnAlarmUsecase
    private(set) var getOnAlarmStatus: GetOnAlarmStatus
    private var cancellable: AnyCancellable?
    @Published private(set) var message: String?

    init(usecase: GetOnAlarmUsecase, currentStatus: GetOnAlarmStatus) {
        self.usecase = usecase
        self.getOnAlarmStatus = currentStatus
        self.message = nil
        self.cancellable = nil
        self.execute()
        self.configureObserver()
    }

    private func configureObserver() {
        NotificationCenter.default.addObserver(forName: .fifteenSecondsPassed, object: nil, queue: .main) { _ in
            print("ewifjwofj")
            self.fetch()
        }
    }

    private func execute() {
        self.cancellable = self.usecase.$busPosition
            .receive(on: GetOnAlarmUsecase.queue)
            .sink { [weak self] position in
                guard let self = self,
                      let position = position else { return }

                if let status = BusApproachCheckUsecase().execute(currentOrd: Int(position.stationOrd)!,
                                                                  beforeOrd: self.getOnAlarmStatus.currentBusOrd ?? Int(position.stationOrd)!,
                                                                  targetOrd: self.getOnAlarmStatus.targetOrd) {
                    self.makeMessage(with: status)
                }
                self.getOnAlarmStatus = GetOnAlarmStatus(getOnAlarmStatus: self.getOnAlarmStatus, currentBusOrd: Int(position.stationOrd)!)
            }
    }

    func fetch() {
        self.usecase.fetch(withVehId: "\(self.getOnAlarmStatus.vehicleId)")
    }

    private func makeMessage(with status: BusApproachStatus) {
        self.message = "\(self.getOnAlarmStatus.busName)번 버스가 \(status.rawValue)번째 전 정류장에 도착하였습니다."
    }
}
