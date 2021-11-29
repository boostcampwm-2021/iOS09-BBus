//
//  BusRouteUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

protocol BaseBusRouteAPIUsable: BaseUseCase {

}

final class BusRouteAPIUsecase: BaseBusRouteAPIUsable {

    private let usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase
    @Published var networkError: Error?

    init(usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase) {
        self.usecases = usecases
        self.networkError = nil
    }

    func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Never> {
        return self.usecases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .tryMap({ routeList -> BusRouteDTO? in
                let header = routeList.filter { $0.routeID == busRouteId }.first
                return header
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
            .tryMap({ item in
                return item.msgBody.itemList
            })
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .eraseToAnyPublisher()
    }
}
