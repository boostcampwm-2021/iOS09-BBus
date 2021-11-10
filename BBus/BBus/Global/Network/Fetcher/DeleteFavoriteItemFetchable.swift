//
//  DeleteFavoriteItemFetchable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol DeleteFavoriteItemFetchable {
    func fetch(param: FavoriteItem) -> AnyPublisher<Data, Error>
}

class PersistentDeleteFavoriteItemFetcher: DeleteFavoriteItemFetchable {
    func fetch(param: FavoriteItem) -> AnyPublisher<Data, Error> {
        return Persistent.shared.delete(key: "FavoriteItems", param: param)
    }
}
