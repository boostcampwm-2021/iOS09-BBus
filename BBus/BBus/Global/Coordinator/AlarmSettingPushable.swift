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
        let coordinator = AlarmSettingCoordinator(presenter: self.navigationPresenter)
        coordinator.delegate = self.delegate
        self.delegate?.addChild(coordinator)
        // TODO: set MovingStatusOpenCloseDelegate
        coordinator.start()
    }
}
