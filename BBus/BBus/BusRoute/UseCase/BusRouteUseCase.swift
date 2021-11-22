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
    @Published var networkError: Error?
    private var cancellables: Set<AnyCancellable>
    static let queue = DispatchQueue(label: "BusRoute")

    init(usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase) {
        self.usecases = usecases
        self.cancellables = []
        self.networkError = nil
    }

    func searchHeader(busRouteId: Int) {
        Self.queue.async { [weak self] in
            guard let self = self else { return }

            self.usecases.getRouteList()
                .receive(on: Self.queue)
                .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
                .tryMap({ routeList -> BusRouteDTO in
                    let headers = routeList.filter { $0.routeID == busRouteId }
                    guard let header = headers.first else { throw BBusAPIError.wrongFormatError }
                    return header
                })
                .retry({
                    self.searchHeader(busRouteId: busRouteId)
                }, handler: { error in
                    self.networkError = error
                })
                .assign(to: \.header, on: self)
                .store(in: &self.cancellables)
        }
    }

    func fetchRouteList(busRouteId: Int) {
        Self.queue.async { [weak self] in
            guard let self = self else { return }

            self.usecases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
                .receive(on: Self.queue)
                .tryMap({ stationsByRouteList -> [StationByRouteListDTO] in
                    guard let result = BBusXMLParser().parse(dtoType: StationByRouteResult.self, xml: stationsByRouteList) else { throw BBusAPIError.wrongFormatError }
                    return result.body.itemList
                })
                .retry({
                    self.fetchRouteList(busRouteId: busRouteId)
                }, handler: { error in
                    self.networkError = error
                })
                .assign(to: \.bodys, on: self)
                .store(in: &self.cancellables)
        }
    }

    func fetchBusPosList(busRouteId: Int) {
        Self.queue.async { [weak self] in
            guard let self = self else { return }

            self.usecases.getBusPosByRtid(busRoutedId: "\(busRouteId)")
                .receive(on: Self.queue)
                .tryMap({ busPosByRtidList in
                    guard let result = BBusXMLParser().parse(dtoType: BusPosByRtidResult.self, xml: busPosByRtidList) else { throw BBusAPIError.wrongFormatError }
                    return result.body.itemList
                })
                .retry({
                    self.fetchBusPosList(busRouteId: busRouteId)
                }, handler: { error in
                    self.networkError = error
                })
                .assign(to: \.buses, on: self)
                .store(in: &self.cancellables)
        }
    }
}
