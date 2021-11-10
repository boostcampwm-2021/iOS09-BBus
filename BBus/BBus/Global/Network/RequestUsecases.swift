//
//  RequestUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

typealias RequestUsecases = (GetArrInfoByRouteListUsecase & GetRouteInfoItemUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase & GetStationByUidItemUsecase & GetStationsByPosListUsecase & GetRouteListUsecase & GetStationListUsecase & GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & DeleteFavoriteItemUsecase)

// MARK: - API Protocol
protocol GetArrInfoByRouteListUsecase {
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<Data, Error>
}

protocol GetRouteInfoItemUsecase {
    func getArrInfoItem(param: [String: String])
}

protocol GetStationsByRouteListUsecase {
    func getArrInfo(key: String, param: [String: String])
}

protocol GetBusPosByRtidUsecase {
    func getArrInfo(key: String, param: [String: String])
}

protocol GetStationByUidItemUsecase {
    func getArrInfo(key: String, param: [String: String])
}

protocol GetStationsByPosListUsecase {
    func getArrInfo(key: String, param: [String: String])
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
    func createFavoriteItem(param: FavoriteItem) -> AnyPublisher<Data, Error>
}

protocol DeleteFavoriteItemUsecase {
    func deleteFavoriteItem(param: FavoriteItem) -> AnyPublisher<Data, Error>
}
