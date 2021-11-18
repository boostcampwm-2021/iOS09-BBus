//
//  FavoriteItemDTO.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/14.
//

import Foundation

struct FavoriteItemDTO: Codable, Equatable {
    let stId: String
    let busRouteId: String
    let ord: String
    let arsId: String
}
