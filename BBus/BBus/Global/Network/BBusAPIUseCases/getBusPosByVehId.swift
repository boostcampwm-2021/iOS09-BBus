//
//  getBusPosByVehId.swift
//  BBus
//
//  Created by Kang Minsang on 2021/12/01.
//

import Foundation
import Combine

extension BBusAPIUseCases: GetBusPosByVehIdUsable {
    func getBusPosByVehId(_ vehId: String) -> AnyPublisher<Data, Error> {
        let param = ["vehId": vehId, "resultType": "json"]
        let fetcher: GetBusPosByVehIdFetchable = ServiceGetBusPosByVehIdFetcher(networkService: self.networkService,
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
