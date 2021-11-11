//
//  SearchBusViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class SearchViewModel {

    private let usecase: SearchUseCase
    private var cancellables: Set<AnyCancellable> = []
    @Published var keyword: String

    init(usecase: SearchUseCase) {
        self.usecase = usecase
        self.keyword = ""
        self.prepare()
    }

    func configure(keyword: String) {
        self.keyword = keyword
    }

    private func prepare() {

        self.usecase.$routeList
            .receive(on: SearchUseCase.thread)
            .sink(receiveValue: { _ in
                self.$keyword
                    .receive(on: SearchUseCase.thread)
                    .debounce(for: .milliseconds(400), scheduler: SearchUseCase.thread)
                    .sink { keyword in
                        dump(self.usecase.searchBus(by: keyword))
                    }
                    .store(in: &self.cancellables)
            })
            .store(in: &self.cancellables)
    }
}
