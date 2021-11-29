//
//  GetFavoriteItemListFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol GetFavoriteItemListFetchable {
    func fetch() -> AnyPublisher<Data, Error>
}

struct PersistenceGetFavoriteItemListFetcher: PersistenceFetchable, GetFavoriteItemListFetchable {
    private(set) var persistenceStorage: PersistenceStorageProtocol
    
    func fetch() -> AnyPublisher<Data, Error> {
        return self.persistenceStorage.getFromUserDefaults(key: "FavoriteItems")
            .eraseToAnyPublisher()
    }
}
