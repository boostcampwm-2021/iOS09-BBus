//
//  BusRouteUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

protocol BusRouteAPIUsable: BaseUseCase {

}

final class BusRouteAPIUsecase: BusRouteAPIUsable {

    private let usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase
    @Published var header: BusRouteDTO?
    @Published var bodys: [StationByRouteListDTO] = []
    @Published var buses: [BusPosByRtidDTO] = []
    @Published var networkError: Error?

    init(usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase) {
        self.usecases = usecases
        self.networkError = nil
    }

    func searchHeader(busRouteId: Int) {
        self.usecases.getRouteList()
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

    func fetchRouteList(busRouteId: Int) {
        self.usecases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
            .decode(type: StationByRouteResult.self, decoder: JSONDecoder())
            .retry({ [weak self] in
                self?.fetchRouteList(busRouteId: busRouteId)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .map({ item in
                item.msgBody.itemList
            })
            .assign(to: &self.$bodys)
    }

    func fetchBusPosList(busRouteId: Int) {
        self.usecases.getBusPosByRtid(busRoutedId: "\(busRouteId)")
            .decode(type: BusPosByRtidResult.self, decoder: JSONDecoder())
            .tryMap({ item in
                return item.msgBody.itemList
            })
            .retry({ [weak self] in
                self?.fetchBusPosList(busRouteId: busRouteId)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$buses)
    }
}
