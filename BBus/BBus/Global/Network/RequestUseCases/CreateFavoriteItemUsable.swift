//
//  CreateFavoriteItemUsable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol CreateFavoriteItemUsable {
    func createFavoriteItem(param: FavoriteItemDTO) -> AnyPublisher<Data, Error>
}
