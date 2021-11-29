//
//  CreateFavoriteItemFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol CreateFavoriteItemFetchable {
    func fetch(param: FavoriteItemDTO) -> AnyPublisher<Data, Error>
}

struct PersistenceCreateFavoriteItemFetcher: PersistenceFetchable, CreateFavoriteItemFetchable {
    private(set) var persistenceStorage: PersistenceStorageProtocol
    
    func fetch(param: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        return self.persistenceStorage.create(key: "FavoriteItems", param: param)
            .eraseToAnyPublisher()
    }
}
