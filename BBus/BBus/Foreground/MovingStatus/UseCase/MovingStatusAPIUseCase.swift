//
//  MovingStatusAPIUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

protocol MovingStatusAPIUsable: BaseUseCase {
    func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Error>
    func fetchRouteList(busRouteId: Int) -> AnyPublisher<[StationByRouteListDTO], Error>
    func fetchBusPosList(busRouteId: Int) -> AnyPublisher<[BusPosByRtidDTO], Error>
}

final class MovingStatusAPIUseCase: MovingStatusAPIUsable {

    private let usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase

    init(usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase) {
        self.usecases = usecases
    }

    func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Error> {
        return self.usecases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .tryMap({ routeList in
                let headers = routeList.filter({ $0.routeID == busRouteId })
                if let header = headers.first {
                    return header
                }
                else {
                    throw BBusAPIError.wrongFormatError
                }
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
            .tryMap ({ item in
                return item.msgBody.itemList
            })
            .eraseToAnyPublisher()
    }
}
