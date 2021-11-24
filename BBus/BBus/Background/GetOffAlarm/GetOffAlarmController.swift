//
//  GetOffAlarmController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/24.
//

import Foundation
import Combine

final class GetOffAlarmController: NSObject {

    static let shared = GetOffAlarmController()

    @Published private(set) var viewModel: GetOffAlarmViewModel?

    private override init() { }

    func start(targetOrd: Int, busRouteId: Int, arsId: String) -> AlarmStartResult {
        if let viewModel = viewModel {
            return viewModel.causesStartFail(targetOrd: targetOrd, busRouteId: busRouteId)
        }
        else {
            let getOffAlarmStatus = GetOffAlarmStatus(targetOrd: targetOrd,
                                                      busRouteId: busRouteId,
                                                      arsId: arsId)
            self.viewModel = GetOffAlarmViewModel(currentStatus: getOffAlarmStatus)
            return .success
        }
    }

    func stop() {
        self.viewModel = nil
    }

}
