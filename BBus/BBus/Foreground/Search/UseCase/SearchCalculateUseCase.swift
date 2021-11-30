//
//  SearchCalculateUseCase.swift
//  BBus
//
//  Created by 최수정 on 2021/11/30.
//

import Foundation

protocol SearchCalculatable {
    func searchBus(by keyword: String, at routeList: [BusRouteDTO]) -> [BusSearchResult]
    func searchStation(by keyword: String, at stationList: [StationDTO]) -> [StationSearchResult]
}

final class SearchCalculateUseCase: SearchCalculatable {
    func searchBus(by keyword: String, at routeList: [BusRouteDTO]) -> [BusSearchResult] {
        if keyword.isEmpty {
            return []
        }
        else {
            return routeList
                .filter { $0.busRouteName.hasPrefix(keyword) }
                .map { BusSearchResult(busRouteDTO: $0) }
        }
    }
    
    func searchStation(by keyword: String, at stationList: [StationDTO]) -> [StationSearchResult] {
        if keyword.isEmpty {
            return []
        }
        else {
            return stationList
                .map { StationSearchResult(stationName: $0.stationName,
                                           arsId: $0.arsID,
                                           stationNameMatchRanges: $0.stationName.ranges(of: keyword),
                                           arsIdMatchRanges: $0.arsID.ranges(of: keyword)) }
                .filter { !($0.arsIdMatchRanges.isEmpty && $0.stationNameMatchRanges.isEmpty) }
        }
    }
}
