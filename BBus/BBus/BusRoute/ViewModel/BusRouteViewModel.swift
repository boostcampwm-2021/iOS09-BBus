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
        self.bindingHeaderInfo()
        self.bindingBodysInfo()
        self.usecase.searchHeader()
        self.usecase.fetchRouteList()
    }

    private func bindingHeaderInfo() {
        self.usecase.$header
            .receive(on: BusRouteUsecase.thread)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { header in
                self.header = header
            })
            .store(in: &cancellables)
    }

    private func bindingBodysInfo() {
        self.usecase.$bodys
            .receive(on: BusRouteUsecase.thread)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { bodys in
                self.bodys = bodys
            })
            .store(in: &cancellables)
    }
}
