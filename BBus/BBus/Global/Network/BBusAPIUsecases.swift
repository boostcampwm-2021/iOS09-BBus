//
//  BBusAPIUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

class BBusAPIUsecases: RequestUsecases {
    
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<Data, Error> {
        let param = ["stId": stId, "busRouteId": busRouteId, "ord": ord]
        let fetcher: GetArrInfoByRouteListFetchable = ServiceGetArrInfoByRouteListFetcher()
        return fetcher.fetch(param: param)
    }

    func getArrInfoItem(param: [String : String]) {

    }

    func getArrInfo(key: String, param: [String : String]) {

    }

    func createFavoriteItem(key: String, param: [String : String]) {

    }
    
    func getRouteList() -> AnyPublisher<Data, Error> {
        let fetcher: GetRouteListFetchable = PersistentGetRouteListFetcher()
        return fetcher.fetch()
    }
    
    func getStationList() -> AnyPublisher<Data, Error> {
        let fetcher: GetStationListFetchable = PersistentGetStationListFetcher()
        return fetcher.fetch()
    }
    
    func getFavoriteItemList() -> AnyPublisher<Data, Error> {
        let fetcher: GetFavoriteItemListFetchable = PersistentGetFavoriteItemListFetcher()
        return fetcher.fetch()
    }
    
    func createFavoriteItem(param: FavoriteItem) -> AnyPublisher<Data, Error> {
        let fetcher: CreateFavoriteItemFetchable = PersistentCreateFavoriteItemFetcher()
        return fetcher.fetch(param: param)
    }
    
    func deleteFavoriteItem(param: FavoriteItem) -> AnyPublisher<Data, Error> {
        let fetcher: DeleteFavoriteItemFetchable = PersistentDeleteFavoriteItemFetcher()
        return fetcher.fetch(param: param)
    }
}
