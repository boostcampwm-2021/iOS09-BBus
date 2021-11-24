//
//  GetFavoriteItemListFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol GetFavoriteItemListFetchable {
    func fetch(on queue: DispatchQueue) -> AnyPublisher<Data, Error>
}

final class PersistentGetFavoriteItemListFetcher: GetFavoriteItemListFetchable {
    func fetch(on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        return Persistent.shared.getFromUserDefaults(key: "FavoriteItems", on: queue)
    }
}
