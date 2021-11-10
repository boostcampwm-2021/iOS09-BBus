//
//  RequestUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

typealias RequestUsecases = (GetArrInfoByRouteListUsecase & GetRouteInfoItemUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase & GetStationByUidItemUsecase & GetStationsByPosListUsecase & GetRouteListBySearchKeywordUsecase & GetStationsBySearchKeywordUsecase & GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & DeleteFavoriteItemUsecase)
// MARK: - API Protocol
protocol GetArrInfoByRouteListUsecase {
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<(data: Data, response: URLResponse), Error>
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

// MARK: - Search Protocol
protocol GetRouteListBySearchKeywordUsecase {
    func getArrInfo(key: String, param: [String: String])
}

protocol GetStationsBySearchKeywordUsecase {
    func getArrInfo(key: String, param: [String: String])
}

protocol GetFavoriteItemListUsecase {
    func getArrInfo(key: String, param: [String: String])
}

// MARK: - Save Persistent
protocol CreateFavoriteItemUsecase {
    func createFavoriteItem(key: String, param: [String: String])
}

protocol DeleteFavoriteItemUsecase {
    func deleteFavoriteItem(key: String)
}
