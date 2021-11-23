//
//  GetOnStatus.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation

struct GetOnAlarmStatus {
    let currentBusOrd: Int?
    let targetOrd: Int
    let vehicleId: Int
    let busName: String

    init(currentBusOrd: Int?, targetOrd: Int, vehicleId: Int, busName: String) {
        self.currentBusOrd = currentBusOrd
        self.targetOrd = targetOrd
        self.vehicleId = vehicleId
        self.busName = busName
    }

    init(getOnAlarmStatus: GetOnAlarmStatus, currentBusOrd: Int) {
        self.vehicleId = getOnAlarmStatus.vehicleId
        self.targetOrd = getOnAlarmStatus.targetOrd
        self.busName = getOnAlarmStatus.busName
        self.currentBusOrd = currentBusOrd
    }
}
