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
    let busRouteId: Int
    let stationId: Int

    init(currentBusOrd: Int?, targetOrd: Int, vehicleId: Int, busName: String, busRouteId: Int, stationId: Int) {
        self.currentBusOrd = currentBusOrd
        self.targetOrd = targetOrd
        self.vehicleId = vehicleId
        self.busName = busName
        self.busRouteId = busRouteId
        self.stationId = stationId
    }

    func withCurrentBusOrd(_ ord: Int) -> GetOnAlarmStatus {
        return GetOnAlarmStatus(currentBusOrd: ord,
                                targetOrd: self.targetOrd,
                                vehicleId: self.vehicleId,
                                busName: self.busName,
                                busRouteId: self.busRouteId,
                                stationId: self.stationId)
    }
}
