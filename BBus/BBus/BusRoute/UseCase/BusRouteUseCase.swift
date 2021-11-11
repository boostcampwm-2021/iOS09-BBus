//
//  BusRouteUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class BusRouteUsecase {

    private let busRouteId: Int
    private let usecases: GetRouteListUsecase & GetStationsByRouteListUsecase
    @Published var header: BusRouteDTO?
    @Published var bodys: StationByRouteResult?
    private var cancellables: Set<AnyCancellable> = []
    static let thread = DispatchQueue(label: "BusRoute")

    init(usecases: GetRouteListUsecase & GetStationsByRouteListUsecase, busRouteId: Int) {
        self.busRouteId = busRouteId
        self.usecases = usecases
    }

    func searchHeader() {
        self.usecases.getRouteList()
            .receive(on: Self.thread)
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { routeList in
                self.header = routeList.filter { $0.routeID == self.busRouteId }[0]
            })
            .store(in: &cancellables)
    }

    func fetchRouteList() {
        self.usecases.getStationsByRouteList(busRoutedId: "\(self.busRouteId)")
            .receive(on: Self.thread)
            .sink { error in
                if case .failure(let error) = error {
                    print(error)
                }
            } receiveValue: { stationsByRouteList in
                self.bodys = BBusXMLParser().parse(dtoType: StationByRouteResult.self, xml: stationsByRouteList)
            }
            .store(in: &cancellables)
    }
}
