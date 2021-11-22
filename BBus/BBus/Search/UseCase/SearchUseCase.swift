//
//  SearchBusUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class SearchUseCase {
    
    private let usecases: GetRouteListUsecase & GetStationListUsecase
    @Published var routeList: [BusRouteDTO]
    @Published var stationList: [StationDTO]
    @Published var networkError: Error?
    private var cancellables: Set<AnyCancellable>
    static let queue = DispatchQueue(label: "Search")
    
    init(usecases: GetRouteListUsecase & GetStationListUsecase) {
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
        Self.queue.async {
            self.usecases.getRouteList()
                .receive(on: Self.queue)
                .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
                .retry({ [weak self] in
                    self?.startRouteSearch()
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .sink(receiveValue: { [weak self] routeList in
                    self?.routeList = routeList
                })
                .store(in: &self.cancellables)
        }
    }
    
    private func startStationSearch() {
        Self.queue.async {
            self.usecases.getStationList()
                .receive(on: Self.queue)
                .decode(type: [StationDTO].self, decoder: JSONDecoder())
                .retry({ [weak self] in
                    self?.startStationSearch()
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .sink(receiveValue: { [weak self] stationList in
                    self?.stationList = stationList
                })
                .store(in: &self.cancellables)
        }
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
