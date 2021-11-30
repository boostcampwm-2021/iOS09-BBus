//
//  SearchUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class SearchAPIUseCase {
    
    private let usecases: GetRouteListUsable & GetStationListUsable
    @Published var routeList: [BusRouteDTO]
    @Published var stationList: [StationDTO]
    @Published var networkError: Error?
    private var cancellables: Set<AnyCancellable>
    
    init(usecases: GetRouteListUsable & GetStationListUsable) {
        self.usecases = usecases
        self.routeList = []
        self.stationList = []
        self.networkError = nil
        self.cancellables = []
        self.startSearch()
    }
    
    private func startSearch() {
        self.startRouteSearch()
        self.startStationSearch()
    }
    
    private func startRouteSearch() {
        self.usecases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .retry({ [weak self] in
                self?.startRouteSearch()
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$routeList)
    }
    
    private func startStationSearch() {
        self.usecases.getStationList()
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .retry({ [weak self] in
                self?.startStationSearch()
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$stationList)
    }
    
    func searchBus(by keyword: String) -> [BusSearchResult] {
        if keyword == "" {
            return []
        }
        else {
            return routeList.filter { $0.busRouteName.hasPrefix(keyword) }
                            .map { BusSearchResult(busRouteDTO: $0) }
        }
    }
    
    func searchStation(by keyword: String) -> [StationSearchResult] {
        if keyword == "" {
            return []
        }
        else {
            return stationList.map { StationSearchResult(stationName: $0.stationName,
                                                         arsId: $0.arsID,
                                                         stationNameMatchRanges: $0.stationName.ranges(of: keyword),
                                                         arsIdMatchRanges: $0.arsID.ranges(of: keyword)) }
                              .filter { !($0.arsIdMatchRanges.isEmpty && $0.stationNameMatchRanges.isEmpty) }
        }
    }
}
