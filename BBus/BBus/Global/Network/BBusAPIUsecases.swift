//
//  BBusAPIUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

final class BBusAPIUsecases: RequestUsecases {
    
    private let requestFactory: Requestable
    
    init(requestFactory: Requestable) {
        self.requestFactory = requestFactory
    }
    
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<Data, Error> {
        let param = ["stId": stId, "busRouteId": busRouteId, "ord": ord, "resultType": "json"]
        let fetcher: GetArrInfoByRouteListFetchable = ServiceGetArrInfoByRouteListFetcher(tokenManager: TokenManager(), requestFactory: self.requestFactory)
        return fetcher
            .fetch(param: param)
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch(param: param)
            })
            .retry(17)
            .eraseToAnyPublisher()
    }

    func getStationsByRouteList(busRoutedId: String) -> AnyPublisher<Data, Error> {
        let param = ["busRouteId": busRoutedId, "resultType": "json"]
        let fetcher: GetStationsByRouteListFetchable = ServiceGetStationsByRouteListFetcher(tokenManager: TokenManager(), requestFactory: self.requestFactory)
        return fetcher
            .fetch(param: param)
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch(param: param)
            })
            .retry(17)
            .eraseToAnyPublisher()
    }

    func getBusPosByRtid(busRoutedId: String) -> AnyPublisher<Data, Error> {
        let param = ["busRouteId": busRoutedId, "resultType": "json"]
        let fetcher: GetBusPosByRtidFetchable = ServiceGetBusPosByRtidFetcher(tokenManager: TokenManager(), requestFactory: self.requestFactory)
        return fetcher
            .fetch(param: param)
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch(param: param)
            })
            .retry(17)
            .eraseToAnyPublisher()
    }

    func getStationByUidItem(arsId: String) -> AnyPublisher<Data, Error> {
        let param = ["arsId": arsId, "resultType": "json"]
        let fetcher: GetStationByUidItemFetchable = ServiceGetStationByUidItemFetcher(tokenManager: TokenManager(), requestFactory: self.requestFactory)
        return fetcher
            .fetch(param: param)
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch(param: param)
            })
            .retry(17)
            .eraseToAnyPublisher()
    }

    func getBusPosByVehId(_ vehId: String) -> AnyPublisher<Data, Error> {
        let param = ["vehId": vehId, "resultType": "json"]
        let fetcher: GetBusPosByVehIdFetchable = ServiceGetBusPosByVehIdFetcher(tokenManager: TokenManager(), requestFactory: self.requestFactory)
        return fetcher
            .fetch(param: param)
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch(param: param)
            })
            .retry(17)
            .eraseToAnyPublisher()
    }

    func getRouteList() -> AnyPublisher<Data, Error> {
        let fetcher: GetRouteListFetchable = PersistentGetRouteListFetcher()
        return fetcher
            .fetch()
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch()
            })
            .retry(17)
            .eraseToAnyPublisher()
    }
    
    func getStationList() -> AnyPublisher<Data, Error> {
        let fetcher: GetStationListFetchable = PersistentGetStationListFetcher()
        return fetcher
            .fetch()
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch()
            })
            .retry(17)
            .eraseToAnyPublisher()
    }
    
    func getFavoriteItemList() -> AnyPublisher<Data, Error> {
        let fetcher: GetFavoriteItemListFetchable = PersistentGetFavoriteItemListFetcher()
        return fetcher
            .fetch()
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch()
            })
            .retry(17)
            .eraseToAnyPublisher()
    }
    
    func createFavoriteItem(param: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        let fetcher: CreateFavoriteItemFetchable = PersistentCreateFavoriteItemFetcher()
        return fetcher
            .fetch(param: param)
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch(param: param)
            })
            .retry(17)
            .eraseToAnyPublisher()
    }
    
    func deleteFavoriteItem(param: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        let fetcher: DeleteFavoriteItemFetchable = PersistentDeleteFavoriteItemFetcher()
        return fetcher
            .fetch(param: param)
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch(param: param)
            })
            .retry(17)
            .eraseToAnyPublisher()
    }
}
