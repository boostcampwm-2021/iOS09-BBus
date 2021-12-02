//
//  SearchViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class SearchViewModel {

    private let apiUseCase: SearchAPIUsable
    private let calculateUseCase: SearchCalculatable
    private var busRouteList: [BusRouteDTO]
    private var stationList: [StationDTO]
    @Published private var keyword: String
    @Published private(set) var searchResults: SearchResults
    @Published private(set) var networkError: Error?
    private var cancellables: Set<AnyCancellable>
    
    init(apiUseCase: SearchAPIUsable, calculateUseCase: SearchCalculatable) {
        self.apiUseCase = apiUseCase
        self.calculateUseCase = calculateUseCase
        self.keyword = ""
        self.busRouteList = []
        self.stationList = []
        self.searchResults = SearchResults(busSearchResults: [], stationSearchResults: [])
        self.cancellables = []
        
        self.bind()
    }

    func configure(keyword: String) {
        self.keyword = keyword
    }
    
    private func bind() {
        self.bindBusRouteList()
        self.bindStationList()
        self.bindKeyword()
    }
    
    private func bindBusRouteList() {
        self.apiUseCase.loadBusRouteList()
            .catchError { [weak self] error in
                self?.networkError = error
            }
            .sink { [weak self] busRouteList in
                self?.busRouteList = busRouteList
            }
            .store(in: &self.cancellables)
    }
    
    private func bindStationList() {
        self.apiUseCase.loadStationList()
            .catchError { [weak self] error in
                self?.networkError = error
            }
            .sink { [weak self] stationList in
                self?.stationList = stationList
            }
            .store(in: &self.cancellables)
    }

    private func bindKeyword() {
        self.$keyword
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.global())
            .sink { [weak self] keyword in
                guard let self = self else { return }
                
                let busSearchResults = self.calculateUseCase.searchBus(by: keyword, at: self.busRouteList)
                let stationSearchResults = self.calculateUseCase.searchStation(by: keyword, at: self.stationList)
                self.searchResults = SearchResults(busSearchResults: busSearchResults, stationSearchResults: stationSearchResults)
            }
            .store(in: &self.cancellables)
    }
}
