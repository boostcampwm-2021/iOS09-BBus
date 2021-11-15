//
//  GetFavoriteOrder.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/15.
//

import Foundation
import Combine

protocol GetFavoriteOrderListFetchable {
    func fetch(on queue: DispatchQueue) -> AnyPublisher<Data, Error>
}

class PersistentGetFavoriteOrderListFetcher: GetFavoriteOrderListFetchable {
    func fetch(on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        return Persistent.shared.getFromUserDefaults(key: "FavoriteOrders", on: queue)
    }
}
