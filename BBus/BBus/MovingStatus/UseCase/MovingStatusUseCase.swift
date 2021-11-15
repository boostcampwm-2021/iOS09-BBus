//
//  MovingStatusUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class MovingStatusUsecase {

    private let usecases: GetRouteListUsecase & GetStationsByRouteListUsecase
    @Published var header: BusRouteDTO?
    @Published var bodys: [StationByRouteListDTO] = []

    private var cancellables: Set<AnyCancellable> = []
    static let queue = DispatchQueue(label: "MovingStatus")

    init(usecases: GetRouteListUsecase & GetStationsByRouteListUsecase) {
        self.usecases = usecases
    }

    func searchHeader(busRouteId: Int) {
        self.usecases.getRouteList()
            .receive(on: Self.queue)
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { routeList in
                self.header = routeList.filter { $0.routeID == busRouteId }[0]
            })
            .store(in: &cancellables)
    }

    func fetchRouteList(busRouteId: Int) {
        self.usecases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
            .receive(on: Self.queue)
            .sink { error in
                if case .failure(let error) = error {
                    print(error)
                }
            } receiveValue: { stationsByRouteList in
                guard let result = BBusXMLParser().parse(dtoType: StationByRouteResult.self, xml: stationsByRouteList) else { return }
                self.bodys = result.body.itemList
            }
            .store(in: &cancellables)
    }
}
