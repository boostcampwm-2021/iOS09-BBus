//
//  BusRouteUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class BusRouteUsecase {

    private let usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase
    @Published var header: BusRouteDTO?
    @Published var bodys: [StationByRouteListDTO] = []
    @Published var buses: [BusPosByRtidDTO] = []
    private var cancellables: Set<AnyCancellable>
    static let queue = DispatchQueue(label: "BusRoute")

    init(usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase) {
        self.usecases = usecases
        self.cancellables = []
    }

    func searchHeader(busRouteId: Int) {
        self.usecases.getRouteList()
            .receive(on: Self.queue)
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { [weak self] routeList in
                let headers = routeList.filter { $0.routeID == busRouteId }
                guard let header = headers.first else { return }
                self?.header = header
            })
            .store(in: &self.cancellables)
    }

    func fetchRouteList(busRouteId: Int) {
        self.usecases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
            .receive(on: Self.queue)
            .sink { error in
                if case .failure(let error) = error {
                    print(error)
                }
            } receiveValue: { [weak self] stationsByRouteList in
                guard let result = BBusXMLParser().parse(dtoType: StationByRouteResult.self, xml: stationsByRouteList) else { return }
                self?.bodys = result.body.itemList
            }
            .store(in: &self.cancellables)
    }

    func fetchBusPosList(busRouteId: Int) {
        self.usecases.getBusPosByRtid(busRoutedId: "\(busRouteId)")
            .receive(on: Self.queue)
            .sink { error in
                if case .failure(let error) = error {
                    print(error)
                }
            } receiveValue: { [weak self] busPosByRtidList in
                guard let result = BBusXMLParser().parse(dtoType: BusPosByRtidResult.self, xml: busPosByRtidList) else { return }
                self?.buses = result.body.itemList
            }
            .store(in: &self.cancellables)
    }
}
