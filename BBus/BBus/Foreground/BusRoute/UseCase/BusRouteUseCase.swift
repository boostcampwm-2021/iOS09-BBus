//
//  BusRouteUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

protocol BaseBusRouteAPIUsable: BaseUseCase {
    func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Error>
    func fetchRouteList(busRouteId: Int) -> AnyPublisher<[StationByRouteListDTO], Error>
    func fetchBusPosList(busRouteId: Int) -> AnyPublisher<[BusPosByRtidDTO], Error>
}

final class BusRouteAPIUseCase: BaseBusRouteAPIUsable {

    private let usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase

    init(usecases: GetRouteListUseCase & GetStationsByRouteListUseCase & GetBusPosByRtidUseCase) {
        self.usecases = usecases
    }

    func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Error> {
        return self.usecases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .tryMap({ routeList -> BusRouteDTO? in
                let header = routeList.filter { $0.routeID == busRouteId }.first
                return header
            })
            .eraseToAnyPublisher()
    }

    func fetchRouteList(busRouteId: Int) -> AnyPublisher<[StationByRouteListDTO], Error> {
        return self.usecases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
            .decode(type: StationByRouteResult.self, decoder: JSONDecoder())
            .map({ item in
                item.msgBody.itemList
            })
            .eraseToAnyPublisher()
    }

    func fetchBusPosList(busRouteId: Int) -> AnyPublisher<[BusPosByRtidDTO], Error> {
        return self.usecases.getBusPosByRtid(busRoutedId: "\(busRouteId)")
            .decode(type: BusPosByRtidResult.self, decoder: JSONDecoder())
            .tryMap({ item in
                return item.msgBody.itemList
            })
            .eraseToAnyPublisher()
    }
}
