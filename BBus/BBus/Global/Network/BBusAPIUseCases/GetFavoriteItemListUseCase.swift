//
//  GetFavoriteItemListUseCase.swift
//  BBus
//
//  Created by Kang Minsang on 2021/12/01.
//

import Foundation
import Combine

extension BBusAPIUseCases: GetFavoriteItemListUsable {
    func getFavoriteItemList() -> AnyPublisher<Data, Error> {
        let fetcher: GetFavoriteItemListFetchable = PersistenceGetFavoriteItemListFetcher(persistenceStorage: self.persistenceStorage)
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
