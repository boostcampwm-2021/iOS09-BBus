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

    var status: (vehicleId: Int, targetOrd: Int)? {
        get {
            guard let viewModel = self.viewModel else { return nil }
            return (viewModel.getOnAlarmStatus.vehicleId, viewModel.getOnAlarmStatus.targetOrd)
        }
    }

    private(set) var viewModel: GetOnAlarmViewModel?
    
    private init() { }

    func start(targetOrd: Int, vehicleId: Int, busName: String) {
        let usecase = GetOnAlarmUsecase(usecases: BBusAPIUsecases(on: GetOnAlarmUsecase.queue))
        let getOnAlarmStatus = GetOnAlarmStatus(currentBusOrd: nil,
                                                targetOrd: targetOrd,
                                                vehicleId: vehicleId,
                                                busName: busName)
        self.viewModel = GetOnAlarmViewModel(usecase: usecase, currentStatus: getOnAlarmStatus)
        self.viewModel?.fetch()
    }

    func stop() {
        self.viewModel = nil
    }

}
