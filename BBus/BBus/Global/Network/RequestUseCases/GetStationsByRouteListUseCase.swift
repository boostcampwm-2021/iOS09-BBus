//
//  GetStationsByRouteListUseCase.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetStationsByRouteListUseCase {
    func getStationsByRouteList(busRoutedId: String) -> AnyPublisher<Data, Error>
}

extension BBusAPIUseCases: GetStationsByRouteListUseCase {
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
