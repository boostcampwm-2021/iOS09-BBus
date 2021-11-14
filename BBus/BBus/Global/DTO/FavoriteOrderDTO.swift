//
//  FavoriteOrderDTO.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/15.
//

import Foundation

struct FavoriteOrderDTO: Codable, Equatable {
    static func == (lhs: FavoriteOrderDTO, rhs: FavoriteOrderDTO) -> Bool {
        return lhs.stationId == rhs.stationId
    }

    let stationId: String
    let order: Int
}
