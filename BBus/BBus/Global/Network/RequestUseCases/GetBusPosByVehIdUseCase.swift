//
//  GetBusPosByVehIdUseCase.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetBusPosByVehIdUseCase {
    func getBusPosByVehId(_ vehId: String) -> AnyPublisher<Data, Error>
}

extension BBusAPIUseCases: GetBusPosByVehIdUseCase {
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
