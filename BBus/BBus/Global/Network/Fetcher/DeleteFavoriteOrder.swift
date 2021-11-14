//
//  DeleteFavoriteOrder.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/15.
//

import Foundation
import Combine

protocol DeleteFavoriteOrderFetchable {
    func fetch(param: FavoriteOrderDTO, on queue: DispatchQueue) -> AnyPublisher<Data, Error>
}

class PersistentDeleteFavoriteOrderFetcher: DeleteFavoriteOrderFetchable {
    func fetch(param: FavoriteOrderDTO, on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        return Persistent.shared.delete(key: "FavoriteOrders", param: param, on: queue)
    }
}
