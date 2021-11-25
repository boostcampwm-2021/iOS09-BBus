//
//  RequestUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

typealias RequestUsecases = (GetArrInfoByRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase & GetStationByUidItemUsecase & GetRouteListUsecase & GetStationListUsecase & GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & DeleteFavoriteItemUsecase & GetBusPosByVehIdUsecase)

// MARK: - API Protocol
protocol GetArrInfoByRouteListUsecase {
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<Data, Error>
}

protocol GetStationsByRouteListUsecase {
    func getStationsByRouteList(busRoutedId: String) -> AnyPublisher<Data, Error>
}

protocol GetBusPosByRtidUsecase {
    func getBusPosByRtid(busRoutedId: String) -> AnyPublisher<Data, Error>
}

protocol GetStationByUidItemUsecase {
    func getStationByUidItem(arsId: String) -> AnyPublisher<Data, Error>
}

protocol GetRouteListUsecase {
    func getRouteList() -> AnyPublisher<Data, Error>
}

protocol GetStationListUsecase {
    func getStationList() -> AnyPublisher<Data, Error>
}

protocol GetFavoriteItemListUsecase {
    func getFavoriteItemList() -> AnyPublisher<Data, Error>
}

protocol CreateFavoriteItemUsecase {
    func createFavoriteItem(param: FavoriteItemDTO) -> AnyPublisher<Data, Error>
}

protocol DeleteFavoriteItemUsecase {
    func deleteFavoriteItem(param: FavoriteItemDTO) -> AnyPublisher<Data, Error>
}

protocol GetBusPosByVehIdUsecase {
    func getBusPosByVehId(_ vehId: String) -> AnyPublisher<Data, Error>
}
