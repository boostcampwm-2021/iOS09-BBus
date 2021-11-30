//
//  GetRouteListUsable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetRouteListUsable {
    func getRouteList() -> AnyPublisher<Data, Error>
}

extension BBusAPIUseCases: GetRouteListUsable {
    func getRouteList() -> AnyPublisher<Data, Error> {
        let fetcher: GetRouteListFetchable = PersistenceGetRouteListFetcher(persistenceStorage: self.persistenceStorage)
        return fetcher
            .fetch()
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                return fetcher
                    .fetch()
            })
            .retry(TokenManager.maxTokenCount)
            .eraseToAnyPublisher()
    }
}