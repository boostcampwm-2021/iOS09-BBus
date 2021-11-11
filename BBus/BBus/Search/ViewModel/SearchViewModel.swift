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
    private var cancellables: Set<AnyCancellable>
    @Published private var keyword: String
    @Published private(set) var busSearchResult: [BusRouteDTO] = []
    
    init(usecase: SearchUseCase) {
        self.usecase = usecase
        self.keyword = ""
        self.cancellables = []
        self.prepare()
    }

    func configure(keyword: String) {
        self.keyword = keyword
    }

    private func prepare() {
//        self.usecase.$routeList
//            .receive(on: SearchUseCase.thread)
//            .sink(receiveValue: { _ in
                self.$keyword
                    .receive(on: SearchUseCase.thread)
                    .debounce(for: .milliseconds(400), scheduler: SearchUseCase.thread)
                    .sink { keyword in
                        guard let busSearchResult = self.usecase.searchBus(by: keyword) else { return }
                        self.busSearchResult = busSearchResult
                    }
                    .store(in: &self.cancellables)
//            })
//            .store(in: &self.cancellables)
    }
}
