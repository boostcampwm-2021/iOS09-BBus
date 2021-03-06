//
//  GetStationsByRouteListUseCase.swift
//  BBus
//
//  Created by Kang Minsang on 2021/12/01.
//

import Foundation
import Combine

extension BBusAPIUseCases: GetStationsByRouteListUsable {
    func getStationsByRouteList(busRoutedId: String) -> AnyPublisher<Data, Error> {
        let param = ["busRouteId": busRoutedId, "resultType": "json"]
        let fetcher: GetStationsByRouteListFetchable = ServiceGetStationsByRouteListFetcher(networkService: self.networkService,
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
