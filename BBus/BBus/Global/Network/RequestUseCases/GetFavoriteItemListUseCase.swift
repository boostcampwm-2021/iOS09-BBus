//
//  GetFavoriteItemListUseCase.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetFavoriteItemListUseCase {
    func getFavoriteItemList() -> AnyPublisher<Data, Error>
}

extension BBusAPIUseCases: GetFavoriteItemListUseCase {
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
