//
//  SearchViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class SearchViewModel {
    
    typealias DecoratedBusResult = (busRouteName: NSMutableAttributedString, routeType: NSMutableAttributedString, routeId: Int)

    let usecase: SearchUseCase
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
            .receive(on: SearchUseCase.queue)
            .debounce(for: .milliseconds(400), scheduler: SearchUseCase.queue)
            .sink { [weak self] keyword in
                guard let self = self else { return }
                self.searchResults.busSearchResults = self.usecase.searchBus(by: keyword)
                self.searchResults.stationSearchResults = self.usecase.searchStation(by: keyword)
            }
            .store(in: &self.cancellables)
    }
}
