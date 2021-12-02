//
//  DeleteFavoriteItemFetchable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol DeleteFavoriteItemFetchable: PersistenceFetchable {
    func fetch(param: FavoriteItemDTO) -> AnyPublisher<Data, Error>
}

struct PersistenceDeleteFavoriteItemFetcher: DeleteFavoriteItemFetchable {
    private(set) var persistenceStorage: PersistenceStorageProtocol
    
    func fetch(param: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        return self.persistenceStorage.delete(key: "FavoriteItems", param: param)
            .eraseToAnyPublisher()
    }
}
