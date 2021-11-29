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

struct PersistentGetFavoriteItemListFetcher: GetFavoriteItemListFetchable {
    func fetch() -> AnyPublisher<Data, Error> {
        return PersistenceStorage.shared.getFromUserDefaults(key: "FavoriteItems")
            .eraseToAnyPublisher()
    }
}
