//
//  GetOnAlarmDelegate.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation
import Combine

final class GetOnAlarmController {
    
    static private let alarmIdentifier: String = "GetOnAlarm"

    static let shared = GetOnAlarmController(alarmCenter: AlarmCenter())
    
    private let alarmCenter: AlarmManagable
    private var cancellables: Set<AnyCancellable>

    @Published private(set) var viewModel: GetOnAlarmInteractor?
    
    private init(alarmCenter: AlarmManagable) {
        self.alarmCenter = alarmCenter
        self.cancellables = []
    }

    func start(targetOrd: Int, vehicleId: Int, busName: String, busRouteId: Int, stationId: Int) -> AlarmStartResult {
        if self.viewModel != nil {
            if isSameAlarm(targetOrd: targetOrd, vehicleId: vehicleId) {
                return .sameAlarm
            }
            else {
                return .duplicated
            }
        }
        else {
            let apiUseCases = BBusAPIUseCases(networkService: NetworkService(),
                                              persistenceStorage: PersistenceStorage(),
                                              tokenManageType: TokenManager.self,
                                              requestFactory: RequestFactory())
            let useCase = GetOnAlarmAPIUseCase(useCases: apiUseCases)
            let getOnAlarmStatus = GetOnAlarmStatus(currentBusOrd: nil,
                                                    targetOrd: targetOrd,
                                                    vehicleId: vehicleId,
                                                    busName: busName,
                                                    busRouteId: busRouteId,
                                                    stationId: stationId)
            self.viewModel = GetOnAlarmInteractor(useCase: useCase, currentStatus: getOnAlarmStatus)
            self.viewModel?.fetch()
            self.binding()
            self.alarmCenter.configurePermission()
            return .success
        }
    }
    
    func stop() {
        self.viewModel = nil
        self.cancellables = []
    }
    
    private func binding() {
        self.bindMessage()
        self.bindErrorMessage()
    }
    
    private func bindMessage() {
        self.viewModel?.$busApproachStatus
            .sink(receiveValue: { [weak self] status in
                guard let status = status,
                      let message = self?.viewModel?.message else { return }
                if status == .oneStationLeft {
                    self?.stop()
                }
                self?.alarmCenter.pushAlarm(in: Self.alarmIdentifier,
                                            title: "승차 알람",
                                            message: message)
            })
            .store(in: &self.cancellables)
    }
    
    private func bindErrorMessage() {
        self.viewModel?.$networkErrorMessage
            .sink(receiveValue: { [weak self] content in
                guard let content = content else { return }
                self?.alarmCenter.pushAlarm(in: Self.alarmIdentifier,
                                            title: content.title,
                                            message: content.body)
                self?.stop()
            })
            .store(in: &self.cancellables)
    }

    private func isSameAlarm(targetOrd: Int, vehicleId: Int) -> Bool {
        guard let currentTargetOrd = self.viewModel?.getOnAlarmStatus.targetOrd,
              let currentVehicleId = self.viewModel?.getOnAlarmStatus.vehicleId else { return false }

        return currentTargetOrd == targetOrd && currentVehicleId == vehicleId
    }
}
