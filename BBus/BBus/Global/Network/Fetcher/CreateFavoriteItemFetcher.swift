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

struct PersistentCreateFavoriteItemFetcher: CreateFavoriteItemFetchable {
    func fetch(param: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        return Persistent.shared.create(key: "FavoriteItems", param: param)
            .compactMap({$0})
            .eraseToAnyPublisher()
    }
}
