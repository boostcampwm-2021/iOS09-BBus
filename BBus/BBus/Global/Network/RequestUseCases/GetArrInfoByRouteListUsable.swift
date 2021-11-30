//
//  GetArrInfoByRouteListUsable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetArrInfoByRouteListUsable {
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<Data, Error>
}

extension BBusAPIUseCases: GetArrInfoByRouteListUsable {
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<Data, Error> {
        let param = ["stId": stId, "busRouteId": busRouteId, "ord": ord, "resultType": "json"]
        let fetcher: GetArrInfoByRouteListFetchable = ServiceGetArrInfoByRouteListFetcher(networkService: self.networkService,
                                                                                          tokenManager: self.tokenManageType.init(),
                                                                                          requestFactory: self.requestFactory)
        return fetcher
            .fetch(param: param)
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch(param: param)
            })
            .retry(TokenManager.maxTokenCount)
            .eraseToAnyPublisher()
    }
}