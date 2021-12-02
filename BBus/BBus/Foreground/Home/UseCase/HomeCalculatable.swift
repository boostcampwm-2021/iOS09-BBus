//
//  HomeCalculatable.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
//

import Foundation

protocol HomeCalculateUsable: BaseUseCase {
    func findStationName(in list: [StationDTO]?, by stationId: String) -> String?
    func findBusName(in list: [BusRouteDTO]?, by busRouteId: String) -> String?
    func findBusType(in list: [BusRouteDTO]?, by busName: String) -> RouteType?
}
