//
//  SearchCalculatable.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
//

import Foundation

protocol SearchCalculatable {
    func searchBus(by keyword: String, at routeList: [BusRouteDTO]) -> [BusSearchResult]
    func searchStation(by keyword: String, at stationList: [StationDTO]) -> [StationSearchResult]
}
