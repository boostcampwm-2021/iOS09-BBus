//
//  RequestUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

typealias RequestUsecases = (GetArrInfoByRouteListUseCase & GetStationsByRouteListUseCase & GetBusPosByRtidUseCase & GetStationByUidItemUseCase & GetRouteListUseCase & GetStationListUseCase & GetFavoriteItemListUseCase & CreateFavoriteItemUseCase & DeleteFavoriteItemUseCase & GetBusPosByVehIdUseCase)

// MARK: - API Protocol
protocol GetArrInfoByRouteListUseCase {
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<Data, Error>
}

protocol GetStationsByRouteListUseCase {
    func getStationsByRouteList(busRoutedId: String) -> AnyPublisher<Data, Error>
}

protocol GetBusPosByRtidUseCase {
    func getBusPosByRtid(busRoutedId: String) -> AnyPublisher<Data, Error>
}

protocol GetStationByUidItemUseCase {
    func getStationByUidItem(arsId: String) -> AnyPublisher<Data, Error>
}

protocol GetRouteListUseCase {
    func getRouteList() -> AnyPublisher<Data, Error>
}

protocol GetStationListUseCase {
    func getStationList() -> AnyPublisher<Data, Error>
}

protocol GetFavoriteItemListUseCase {
    func getFavoriteItemList() -> AnyPublisher<Data, Error>
}

protocol CreateFavoriteItemUseCase {
    func createFavoriteItem(param: FavoriteItemDTO) -> AnyPublisher<Data, Error>
}

protocol DeleteFavoriteItemUseCase {
    func deleteFavoriteItem(param: FavoriteItemDTO) -> AnyPublisher<Data, Error>
}

protocol GetBusPosByVehIdUseCase {
    func getBusPosByVehId(_ vehId: String) -> AnyPublisher<Data, Error>
}
