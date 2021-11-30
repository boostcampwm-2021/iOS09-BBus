//
//  getStationByUidItem.swift
//  BBus
//
//  Created by Kang Minsang on 2021/12/01.
//

import Foundation
import Combine

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
