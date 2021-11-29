//
//  HomeCalculateUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/29.
//

import Foundation

protocol HomeCalculateUsable: BaseUseCase {
    func findStationName(in list: [StationDTO]?, by stationId: String) -> String?
    func findBusName(in list: [BusRouteDTO]?, by busRouteId: String) -> String?
    func findBusType(in list: [BusRouteDTO]?, by busName: String) -> RouteType?
}

struct HomeCalculateUseCase: HomeCalculateUsable {
    func findStationName(in list: [StationDTO]?, by stationId: String) -> String? {
        guard let stationId = Int(stationId),
              let stationName = list?.first(where: { $0.stationID == stationId })?.stationName else { return nil }

        return stationName
    }

    func findBusName(in list: [BusRouteDTO]?, by busRouteId: String) -> String? {
        guard let busRouteId = Int(busRouteId),
              let busName = list?.first(where: { $0.routeID == busRouteId })?.busRouteName else { return nil }

        return busName
    }

    func findBusType(in list: [BusRouteDTO]?, by busName: String) -> RouteType? {
        return list?.first(where: { $0.busRouteName == busName } )?.routeType
    }
}
