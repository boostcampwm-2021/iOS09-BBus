//
//  CreateFavoriteItemFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol CreateFavoriteItemFetchable {
    func fetch(param: FavoriteItemDTO, on queue: DispatchQueue) -> AnyPublisher<Data, Error>
}

final class PersistentCreateFavoriteItemFetcher: CreateFavoriteItemFetchable {
    func fetch(param: FavoriteItemDTO, on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        return Persistent.shared.create(key: "FavoriteItems", param: param, on: queue)
    }
}
