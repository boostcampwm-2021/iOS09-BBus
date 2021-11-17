//
//  Pushables.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/09.
//

import Foundation
import UIKit

protocol BusRoutePushable: Coordinator {
    func pushToBusRoute(busRouteId: Int)
}

extension BusRoutePushable {
    func pushToBusRoute(busRouteId: Int) {
        self.delegate?.pushBusRoute(busRouteId: busRouteId)
    }
}

protocol SearchPushable: Coordinator {
    func pushToSearch()
}

extension SearchPushable {
    func pushToSearch() {
        self.delegate?.pushSearch()
    }
}

protocol AlarmSettingPushable: Coordinator {
    func pushToAlarmSetting(stationId: Int, busRouteId: Int, stationOrd: Int, arsId: String, routeType: RouteType?, busName: String)
}

extension AlarmSettingPushable {
    func pushToAlarmSetting(stationId: Int, busRouteId: Int, stationOrd: Int, arsId: String, routeType: RouteType?, busName: String) {
        self.delegate?.pushAlarmSetting(stationId: stationId,
                                        busRouteId: busRouteId,
                                        stationOrd: stationOrd,
                                        arsId: arsId,
                                        routeType: routeType,
                                        busName: busName)
    }
}

protocol StationPushable: Coordinator {
    func pushToStation(arsId: String)
}

extension StationPushable {
    func pushToStation(arsId: String) {
        self.delegate?.pushStation(arsId: arsId)
    }
}

protocol AlertPushable: Coordinator {
    func pushAlert(controller: UIAlertController, completion: (() -> Void)?)
}

extension AlertPushable {
    func pushAlert(controller: UIAlertController, completion: (() -> Void)? = nil) {
        self.delegate?.pushAlert(controller: controller, completion: completion)
    }
}
