//
//  CreateFavoriteItemUsable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol CreateFavoriteItemUsable {
    func createFavoriteItem(param: FavoriteItemDTO) -> AnyPublisher<Data, Error>
}

extension BBusAPIUseCases: CreateFavoriteItemUsable {
    func createFavoriteItem(param: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        let fetcher: CreateFavoriteItemFetchable = PersistenceCreateFavoriteItemFetcher(persistenceStorage: self.persistenceStorage)
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
