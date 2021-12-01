//
//  BusRouteDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/10.
//

import Foundation

struct BusRouteDTO: Codable {
    let routeID: Int
    let busRouteName: String
    let routeType: RouteType
    let startStation: String
    let endStation: String
}

enum RouteType: String, Codable {
    case mainLine = "간선"
    case broadArea = "광역"
    case customized = "맞춤"
    case circulation = "순환"
    case lateNight = "심야"
    case localLine = "지선"
    case airport = "공항"
    case town = "마을"
}
