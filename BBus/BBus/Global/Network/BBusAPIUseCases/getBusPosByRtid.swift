//
//  getBusPosByRtid.swift
//  BBus
//
//  Created by Kang Minsang on 2021/12/01.
//

import Foundation
import Combine

extension BBusAPIUseCases: GetBusPosByRtidUsable {
    func getBusPosByRtid(busRoutedId: String) -> AnyPublisher<Data, Error> {
        let param = ["busRouteId": busRoutedId, "resultType": "json"]
        let fetcher: GetBusPosByRtidFetchable = ServiceGetBusPosByRtidFetcher(networkService: self.networkService,
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
