//
//  DeleteFavoriteItemFetchable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol DeleteFavoriteItemFetchable {
    func fetch(param: FavoriteItemDTO) -> AnyPublisher<Data, Error>
}

struct PersistentDeleteFavoriteItemFetcher: DeleteFavoriteItemFetchable {
    func fetch(param: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        return Persistent.shared.delete(key: "FavoriteItems", param: param)
            .compactMap({$0})
            .eraseToAnyPublisher()
    }
}
