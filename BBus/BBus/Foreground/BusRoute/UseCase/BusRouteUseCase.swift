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
        Self.queue.async {
            self.usecases.getRouteList()
                .receive(on: Self.queue)
                .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
                .tryMap({ routeList -> BusRouteDTO? in
                    let header = routeList.filter { $0.routeID == busRouteId }.first
                    return header
                })
                .retry({ [weak self] in
                    self?.searchHeader(busRouteId: busRouteId)
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .assign(to: &self.$header)
        }
    }

    func fetchRouteList(busRouteId: Int) {
        Self.queue.async {
            self.usecases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
                .receive(on: Self.queue)
                .decode(type: StationByRouteResult.self, decoder: JSONDecoder())
                .retry({ [weak self] in
                    self?.fetchRouteList(busRouteId: busRouteId)
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .map({ item in
                    item.msgBody.itemList.map { StationByRouteListDTO(rawDto: $0) }
                })
                .assign(to: &self.$bodys)
        }
    }

    func fetchBusPosList(busRouteId: Int) {
        Self.queue.async {
            self.usecases.getBusPosByRtid(busRoutedId: "\(busRouteId)")
                .receive(on: Self.queue)
                .tryMap({ busPosByRtidList in
                    guard let result = BBusXMLParser().parse(dtoType: BusPosByRtidResult.self, xml: busPosByRtidList) else { throw BBusAPIError.wrongFormatError }
                    return result.body.itemList
                })
                .retry({ [weak self] in
                    self?.fetchBusPosList(busRouteId: busRouteId)
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .assign(to: &self.$buses)
        }
    }
}
