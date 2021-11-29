//
//  MovingStatusAPIUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

protocol MovingStatusAPIUsable: BaseUseCase {
    func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Never>
    func fetchRouteList(busRouteId: Int) -> AnyPublisher<[StationByRouteListDTO], Never>
    func fetchBusPosList(busRouteId: Int) -> AnyPublisher<[BusPosByRtidDTO], Never>
}

final class MovingStatusAPIUseCase: MovingStatusAPIUsable {

    private let usecases: GetRouteListUseCase & GetStationsByRouteListUseCase & GetBusPosByRtidUseCase
    @Published var networkError: Error?

    init(usecases: GetRouteListUseCase & GetStationsByRouteListUseCase & GetBusPosByRtidUseCase) {
        self.usecases = usecases
        self.networkError = nil
    }

    func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Never> {
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
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .eraseToAnyPublisher()
    }

    func fetchRouteList(busRouteId: Int) -> AnyPublisher<[StationByRouteListDTO], Never> {
        return self.usecases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
            .decode(type: StationByRouteResult.self, decoder: JSONDecoder())
            .map({ item in
                item.msgBody.itemList
            })
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .eraseToAnyPublisher()
    }

    func fetchBusPosList(busRouteId: Int) -> AnyPublisher<[BusPosByRtidDTO], Never> {
        return self.usecases.getBusPosByRtid(busRoutedId: "\(busRouteId)")
            .decode(type: BusPosByRtidResult.self, decoder: JSONDecoder())
            .tryMap ({ item in
                return item.msgBody.itemList
            })
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .eraseToAnyPublisher()
    }
}
