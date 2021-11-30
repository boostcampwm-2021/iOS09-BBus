//
//  BusRouteUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class BusRouteAPIUseCase: BusRouteAPIUsable {

    private let useCases: GetRouteListUsable & GetStationsByRouteListUsable & GetBusPosByRtidUsable

    init(useCases: GetRouteListUsable & GetStationsByRouteListUsable & GetBusPosByRtidUsable) {
        self.useCases = useCases
    }

    func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Error> {
        return self.useCases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .tryMap({ routeList -> BusRouteDTO? in
                let header = routeList.filter { $0.routeID == busRouteId }.first
                return header
            })
            .eraseToAnyPublisher()
    }

    func fetchRouteList(busRouteId: Int) -> AnyPublisher<[StationByRouteListDTO], Error> {
        return self.useCases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
            .decode(type: StationByRouteResult.self, decoder: JSONDecoder())
            .map({ item in
                item.msgBody.itemList
            })
            .eraseToAnyPublisher()
    }

    func fetchBusPosList(busRouteId: Int) -> AnyPublisher<[BusPosByRtidDTO], Error> {
        return self.useCases.getBusPosByRtid(busRoutedId: "\(busRouteId)")
            .decode(type: BusPosByRtidResult.self, decoder: JSONDecoder())
            .tryMap({ item in
                return item.msgBody.itemList
            })
            .eraseToAnyPublisher()
    }
}
