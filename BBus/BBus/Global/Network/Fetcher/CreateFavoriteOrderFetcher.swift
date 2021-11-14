//
//  CreateFavoriteOrderFetcher.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/15.
//

import Foundation
import Combine

protocol CreateFavoriteOrderFetchable {
    func fetch(param: FavoriteOrderDTO, on queue: DispatchQueue) -> AnyPublisher<Data, Error>
}

class PersistentCreateFavoriteOrderFetcher: CreateFavoriteOrderFetchable {
    func fetch(param: FavoriteOrderDTO, on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        return Persistent.shared.create(key: "FavoriteOrders", param: param, on: queue)
    }
}
