//
//  BusRouteAPIUsable.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
//

import Foundation
import Combine

protocol BusRouteAPIUsable: BaseUseCase {
    func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Error>
    func fetchRouteList(busRouteId: Int) -> AnyPublisher<[StationByRouteListDTO], Error>
    func fetchBusPosList(busRouteId: Int) -> AnyPublisher<[BusPosByRtidDTO], Error>
}
