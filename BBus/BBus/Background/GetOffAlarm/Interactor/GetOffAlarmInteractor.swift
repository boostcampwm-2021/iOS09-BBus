//
//  GetOffAlarmViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/24.
//

import Foundation
import Combine

class GetOffAlarmInteractor {

    private(set) var getOffAlarmStatus: GetOffAlarmStatus

    init(currentStatus: GetOffAlarmStatus) {
        self.getOffAlarmStatus = currentStatus
    }

    func causesStartFail(targetOrd: Int, busRouteId: Int) -> AlarmStartResult {
        if isSameAlarm(targetOrd: targetOrd, busRouteId: busRouteId) {
            return .sameAlarm
        }
        else {
            return .duplicated
        }
    }

    private func isSameAlarm(targetOrd: Int, busRouteId: Int) -> Bool {
        return self.getOffAlarmStatus.targetOrd == targetOrd && self.getOffAlarmStatus.busRouteId == busRouteId
    }
}
