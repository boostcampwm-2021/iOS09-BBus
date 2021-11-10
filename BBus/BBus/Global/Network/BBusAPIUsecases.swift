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

    func getRouteInfoItem(busRouteId: String) -> AnyPublisher<Data, Error> {
        let param = ["busRouteId": busRouteId]
        let fetcher: GetRouteInfoItemFetchable = ServiceGetRouteInfoItemFetcher()
        return fetcher.fetch(param: param)
    }

    func getStationsByRouteList(busRoutedId: String) -> AnyPublisher<Data, Error> {
        let param = ["busRoutedId": busRoutedId]
        let fetcher: GetStationsByRouteListFetchable = ServiceGetStationsByRouteListFetcher()
        return fetcher.fetch(param: param)
    }

    func getBusPosByRtid(busRoutedId: String) -> AnyPublisher<Data, Error> {
        let param = ["busRoutedId": busRoutedId]
        let fetcher: GetBusPosByRtidFetchable = ServiceGetBusPosByRtidFetcher()
        return fetcher.fetch(param: param)
    }

    func getStationByUidItem(arsId: String) -> AnyPublisher<Data, Error> {
        let param = ["arsId": arsId]
        let fetcher: GetStationByUidItemFetchable = ServiceGetStationByUidItemFetcher()
        return fetcher.fetch(param: param)
    }

    func getStationsByPosList(tmX: String, tmY: String, radius: String) -> AnyPublisher<Data, Error> {
        let param = ["tmX": tmX, "tmY": tmY, "radius": radius]
        let fetcher: GetStationsByPosListFetchable = ServiceGetStationsByPosListFetcher()
        return fetcher.fetch(param: param)
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
