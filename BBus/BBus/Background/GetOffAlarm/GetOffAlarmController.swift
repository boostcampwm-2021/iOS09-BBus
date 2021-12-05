//
//  GetOffAlarmController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/24.
//

import Foundation
import Combine
import CoreLocation

final class GetOffAlarmController {

    static let shared = GetOffAlarmController(alarmCenter: AlarmCenter())

    @Published private(set) var viewModel: GetOffAlarmInteractor?
    private let alarmCenter: AlarmDetailConfigurable

    private init(alarmCenter: AlarmDetailConfigurable) {
        self.alarmCenter = alarmCenter
    }

    func start(targetOrd: Int, busRouteId: Int, arsId: String) -> AlarmStartResult {
        if let viewModel = viewModel {
            return viewModel.causesStartFail(targetOrd: targetOrd, busRouteId: busRouteId)
        }
        else {
            let getOffAlarmStatus = GetOffAlarmStatus(targetOrd: targetOrd,
                                                      busRouteId: busRouteId,
                                                      arsId: arsId)
            self.viewModel = GetOffAlarmInteractor(currentStatus: getOffAlarmStatus)
            return .success
        }
    }

    func stop() {
        self.viewModel = nil
    }
    
    func configureAlarmPermission(_ delegate: CLLocationManagerDelegate) {
        self.alarmCenter.configurePermission()
        self.alarmCenter.configureLocationDetail(delegate)
    }
}
