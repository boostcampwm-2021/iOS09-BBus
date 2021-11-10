//
//  RequestUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation

typealias RequestUsecases = (GetArrInfoByRouteListUsecase & GetRouteInfoItemUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase & GetStationByUidItemUsecase & GetStationsByPosListUsecase & GetRouteListBySearchKeywordUsecase & GetStationsBySearchKeywordUsecase & GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & DeleteFavoriteItemUsecase)
// MARK: - API Protocol
protocol GetArrInfoByRouteListUsecase {
    func getArrInfo(key: String, param: String)
}

protocol GetRouteInfoItemUsecase {
    func getArrInfo(key: String, param: String)
}

protocol GetStationsByRouteListUsecase {
    func getArrInfo(key: String, param: String)
}

protocol GetBusPosByRtidUsecase {
    func getArrInfo(key: String, param: String)
}

protocol GetStationByUidItemUsecase {
    func getArrInfo(key: String, param: String)
}

protocol GetStationsByPosListUsecase {
    func getArrInfo(key: String, param: String)
}

// MARK: - Search Protocol
protocol GetRouteListBySearchKeywordUsecase {
    func getArrInfo(key: String, param: String)
}

protocol GetStationsBySearchKeywordUsecase {
    func getArrInfo(key: String, param: String)
}

protocol GetFavoriteItemListUsecase {
    func getArrInfo(key: String, param: String)
}

// MARK: - Save Persistent
protocol CreateFavoriteItemUsecase {
    func createFavoriteItem(key: String, param: String)
}

protocol DeleteFavoriteItemUsecase {
    func deleteFavoriteItem(key: String)
}
