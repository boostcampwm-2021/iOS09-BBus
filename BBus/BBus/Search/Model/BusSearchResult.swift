//
//  BusSearchResult.swift
//  BBus
//
//  Created by 최수정 on 2021/11/14.
//

import Foundation

struct BusSearchResult {
    let routeID: Int
    let busRouteName: String
    let routeType: RouteType
    
    init(busRouteDTO: BusRouteDTO) {
        self.routeID = busRouteDTO.routeID
        self.busRouteName = busRouteDTO.busRouteName
        self.routeType = busRouteDTO.routeType
    }
}
