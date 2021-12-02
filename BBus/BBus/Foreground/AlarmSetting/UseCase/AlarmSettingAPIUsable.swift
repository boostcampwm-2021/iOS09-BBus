//
//  AlarmSettingAPIUsable.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
//

import Foundation
import Combine

protocol AlarmSettingAPIUsable: BaseUseCase {
    func busArriveInfoWillLoaded(stId: String, busRouteId: String, ord: String) -> AnyPublisher<ArrInfoByRouteDTO, Error>
    func busStationsInfoWillLoaded(busRouetId: String, arsId: String) -> AnyPublisher<[StationByRouteListDTO]?, Error>
}
