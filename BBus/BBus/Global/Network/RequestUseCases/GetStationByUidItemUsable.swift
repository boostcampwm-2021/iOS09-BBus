//
//  GetStationByUidItemUsable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetStationByUidItemUsable {
    func getStationByUidItem(arsId: String) -> AnyPublisher<Data, Error>
}

extension BBusAPIUseCases: GetStationByUidItemUsable {
    func getStationByUidItem(arsId: String) -> AnyPublisher<Data, Error> {
        let param = ["arsId": arsId, "resultType": "json"]
        let fetcher: GetStationByUidItemFetchable = ServiceGetStationByUidItemFetcher(networkService: self.networkService,
                                                                                      tokenManager: TokenManager(),
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
