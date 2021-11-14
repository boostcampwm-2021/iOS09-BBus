//
//  HomeModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation

class HomeFavoriteList {

    private var favorites: [HomeFavorite] = []

    func append(newElement: FavoriteItemDTO) {
        if let found = self.favorites.first(where: { $0.stationId == newElement.stId }) {
            found.append(newElement: newElement)
        }
        else {
            self.favorites.append(HomeFavorite(stationId: newElement.stId, buses: [newElement]))
        }
    }

    func sort(by orderList: [FavoriteOrderDTO]) {
        self.favorites.sort(by: { lhs, rhs in
            guard let lhsOrder = orderList.first(where: { $0.stationId == lhs.stationId })?.order,
                  let rhsOrder = orderList.first(where: { $0.stationId == rhs.stationId })?.order
            else { return true }

            return lhsOrder < rhsOrder
        })
    }
}

class HomeFavorite: Equatable {
    static func == (lhs: HomeFavorite, rhs: HomeFavorite) -> Bool {
        return lhs.stationId == rhs.stationId
    }

    let stationId: String
    private var buses: [FavoriteItemDTO]

    init(stationId: String, buses: [FavoriteItemDTO]) {
        self.stationId = stationId
        self.buses = buses
    }

    func append(newElement: FavoriteItemDTO) {
        self.buses.append(newElement)
    }
}
