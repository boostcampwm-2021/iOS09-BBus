//
//  SearchBusViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class SearchViewModel {
    
    typealias DecoratedBusResult = (busRouteName: NSMutableAttributedString, routeType: NSMutableAttributedString, routeId: Int)

    private let usecase: SearchUseCase
    @Published private var keyword: String
    @Published private(set) var searchResults: SearchResults
    private var cancellables: Set<AnyCancellable>
    
    init(usecase: SearchUseCase) {
        self.usecase = usecase
        self.keyword = ""
        self.searchResults = SearchResults(busSearchResults: [], stationSearchResults: [])
        self.cancellables = []
        self.prepare()
    }

    func configure(keyword: String) {
        self.keyword = keyword
    }

    private func prepare() {
        self.$keyword
            .receive(on: SearchUseCase.thread)
            .debounce(for: .milliseconds(400), scheduler: SearchUseCase.thread)
            .sink { keyword in
                if let busSearchResults = self.usecase.searchBus(by: keyword) {
                    self.searchResults.busSearchResults = busSearchResults
                }
                if let stationSearchResults = self.usecase.searchStation(by: keyword) {
                    self.searchResults.stationSearchResults = stationSearchResults
                }
            }
            .store(in: &self.cancellables)
    }
}
