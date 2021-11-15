//
//  AlarmSettingUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation

class AlarmSettingUseCase {
    static let queue = DispatchQueue.init(label: "alarmSetting")
    
    typealias AlarmSettingUseCases = GetArrInfoByRouteListUsecase
    let usecases: AlarmSettingUseCases
    
    init(usecases: AlarmSettingUseCases) {
        self.usecases = usecases
    }
}
