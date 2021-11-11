//
//  BusRouteViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class BusRouteViewModel {

    private let usecase: BusRouteUsecase
    private var cancellables: Set<AnyCancellable>
    @Published var header: BusRouteDTO?

    init(usecase: BusRouteUsecase) {
        self.usecase = usecase
        self.cancellables = []
        self.getHeaderInfo()
    }

    private func getHeaderInfo() {
        self.usecase.searchHeader()
        self.usecase.$header
            .receive(on: BusRouteUsecase.thread)
            .sink { _ in
                self.header = self.usecase.header
            }
            .store(in: &cancellables)
    }
}
