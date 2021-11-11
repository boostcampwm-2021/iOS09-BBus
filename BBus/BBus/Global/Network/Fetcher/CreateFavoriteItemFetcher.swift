//
//  CreateFavoriteItemFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol CreateFavoriteItemFetchable {
    func fetch(param: FavoriteItem) -> AnyPublisher<Data, Error>
}

class PersistentCreateFavoriteItemFetcher: CreateFavoriteItemFetchable {
    func fetch(param: FavoriteItem) -> AnyPublisher<Data, Error> {
        return Persistent.shared.create(key: "FavoriteItems", param: param)
    }
}
