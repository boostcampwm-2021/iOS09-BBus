//
//  GetRouteListUseCase.swift
//  BBus
//
//  Created by Kang Minsang on 2021/12/01.
//

import Foundation
import Combine

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
