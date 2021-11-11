//
//  BusRouteUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class BusRouteUsecase {

    private let usecases: GetRouteListUsecase
    @Published var header: BusRouteDTO?
    private var cancellable: AnyCancellable?
    static let thread = DispatchQueue(label: "BusRoute")

    init(usecases: GetRouteListUsecase, busRouteId: Int) {
        self.usecases = usecases
        self.searchHeader(busRouteId: busRouteId)
    }

    private func searchHeader(busRouteId: Int) {
        self.cancellable = usecases.getRouteList()
            .receive(on: Self.thread)
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { routeList in
                self.header = routeList.filter { $0.routeID == busRouteId }[0]
            })
    }
}
