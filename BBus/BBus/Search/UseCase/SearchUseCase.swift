//
//  SearchBusUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class SearchUseCase {
    
    private let usecases: GetRouteListUsecase & GetStationListUsecase
    @Published var routeList: [BusRouteDTO]?
    @Published var stationList: [StationDTO]?
    private var cancellables: Set<AnyCancellable> = []
    static let thread = DispatchQueue(label: "Search")
    
    init(usecases: GetRouteListUsecase & GetStationListUsecase) {
        self.usecases = usecases
        self.startSearch()
    }
    
    private func startSearch() {
        self.startRouteSearch()
        self.startStationSearch()
    }
    
    private func startRouteSearch() {
        usecases.getRouteList()
            .receive(on: Self.thread)
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { routeList in
                self.routeList = routeList
            })
            .store(in: &self.cancellables)
    }
    
    private func startStationSearch() {
        usecases.getStationList()
            .receive(on: Self.thread)
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { stationList in
                self.stationList = stationList
            })
            .store(in: &self.cancellables)
    }
    
    func searchBus(by keyword: String) -> [BusRouteDTO]? {
        guard let routeList = self.routeList else { return nil }
        if keyword == "" {
            return []
        }
        else {
            return routeList.filter { $0.busRouteName.hasPrefix(keyword) }
        }
    }
}
