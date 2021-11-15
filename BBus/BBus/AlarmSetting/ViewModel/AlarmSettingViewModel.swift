//
//  AlarmSettingViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation

class AlarmSettingViewModel {
    let stationId: Int
    let busRouteId: Int
    let stationOrd: Int
    let useCase: AlarmSettingUseCase
    
    init(useCase: AlarmSettingUseCase, stationId: Int, busRouteId: Int, stationOrd: Int) {
        self.useCase = useCase
        self.stationId = stationId
        self.busRouteId = busRouteId
        self.stationOrd = stationOrd
    }
}
