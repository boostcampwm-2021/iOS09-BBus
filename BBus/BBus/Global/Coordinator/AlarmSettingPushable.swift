//
//  AlarmSettingPushable.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/03.
//

import Foundation

protocol AlarmSettingPushable: Coordinator {
    func pushToAlarmSetting()
}

extension AlarmSettingPushable {
    func pushToAlarmSetting() {
        let coordinator = AlarmSettingCoordinator(presenter: self.presenter)
        coordinator.delegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
