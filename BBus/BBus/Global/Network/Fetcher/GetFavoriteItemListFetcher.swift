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

class PersistentGetFavoriteItemListFetcher: GetFavoriteItemListFetchable {
    func fetch() -> AnyPublisher<Data, Error> {
        return Persistent.shared.getFromUserDefaults(key: "FavoriteItems")
    }
}
