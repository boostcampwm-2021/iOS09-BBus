//
//  HomeModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation

class HomeFavoriteList {

    private var favorites: [HomeFavorite] = []

    subscript (index: Int) -> HomeFavorite? {
        guard 0..<self.favorites.count ~= index else { return nil }
        return self.favorites[index]
    }

    init(dtoList: [FavoriteItemDTO]) {
        dtoList.forEach({ dto in
            if let found = self.favorites.first(where: { $0.stationId == dto.stId }) {
                found.append(newElement: dto)
            }
            else {
                self.favorites.append(HomeFavorite(stationId: dto.stId,
                                                   arsId: dto.arsId,
                                                   buses: [dto]))
            }
        })
    }

    func count() -> Int {
        return self.favorites.count
    }
}

class HomeFavorite: Equatable {

    subscript(index: Int) -> FavoriteItemDTO? {
        guard 0..<self.buses.count ~= index else { return nil }
        return self.buses[index]
    }

    static func == (lhs: HomeFavorite, rhs: HomeFavorite) -> Bool {
        return lhs.stationId == rhs.stationId
    }

    let stationId: String
    let arsId: String
    private var buses: [FavoriteItemDTO]

    init(stationId: String, arsId: String, buses: [FavoriteItemDTO]) {
        self.stationId = stationId
        self.buses = buses
        self.arsId = arsId
    }

    func append(newElement: FavoriteItemDTO) {
        self.buses.append(newElement)
    }

    func count() -> Int {
        return self.buses.count
    }
}
