//
//  GetOnAlarmDelegate.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation
import UIKit

final class GetOnAlarmController {

    static let shared = GetOnAlarmController()

    @Published private(set) var viewModel: GetOnAlarmViewModel?
    
    private init() { }

    func start(targetOrd: Int, vehicleId: Int, busName: String) -> GetOnStartResult {
        if self.viewModel != nil {
            if isSameAlarm(targetOrd: targetOrd, vehicleId: vehicleId) {
                return .sameAlarm
            }
            else {
                return .duplicated
            }
        }
        else {
            let usecase = GetOnAlarmUsecase(usecases: BBusAPIUsecases(on: GetOnAlarmUsecase.queue))
            let getOnAlarmStatus = GetOnAlarmStatus(currentBusOrd: nil,
                                                    targetOrd: targetOrd,
                                                    vehicleId: vehicleId,
                                                    busName: busName)
            self.viewModel = GetOnAlarmViewModel(usecase: usecase, currentStatus: getOnAlarmStatus)
            self.viewModel?.fetch()
            return .success
        }
    }

    func stop() {
        self.viewModel = nil
    }

    private func isSameAlarm(targetOrd: Int, vehicleId: Int) -> Bool {
        guard let currentTargetOrd = self.viewModel?.getOnAlarmStatus.targetOrd,
              let currentVehicleId = self.viewModel?.getOnAlarmStatus.vehicleId else { return false }

        return currentTargetOrd == targetOrd && currentVehicleId == vehicleId
    }

}
