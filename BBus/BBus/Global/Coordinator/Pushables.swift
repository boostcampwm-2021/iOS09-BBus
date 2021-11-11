//
//  Pushables.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/09.
//

import Foundation

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
    func pushToAlarmSetting()
}

extension AlarmSettingPushable {
    func pushToAlarmSetting() {
        self.delegate?.pushAlarmSetting()
    }
}

protocol StationPushable: Coordinator {
    func pushToStation(stationId: Int)
}

extension StationPushable {
    func pushToStation(stationId: Int) {
        self.delegate?.pushStation(stationId: stationId)
    }
}
