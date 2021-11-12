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
    private var cancellables: Set<AnyCancellable> = []
    @Published var header: BusRouteDTO?
    @Published var bodys: [StationByRouteListDTO] = []

    init(usecase: BusRouteUsecase) {
        self.usecase = usecase
        self.getHeaderInfo()
        self.getBodysInfo()
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

    private func getBodysInfo() {
        self.usecase.fetchRouteList()
        self.usecase.$bodys
            .receive(on: BusRouteUsecase.thread)
            .sink { _ in
                guard let bodys = self.usecase.bodys?.body.itemList else { return }
                self.bodys = bodys
            }
            .store(in: &cancellables)
    }
}
