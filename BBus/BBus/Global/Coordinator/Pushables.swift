//
//  Pushables.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/09.
//

import Foundation

protocol BusRoutePushable: Coordinator {
    func pushToBusRoute()
}

extension BusRoutePushable {
    func pushToBusRoute() {
        self.delegate?.pushBusRoute()
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
    func pushToStation()
}

extension StationPushable {
    func pushToStation() {
        self.delegate?.pushStation()
    }
}
