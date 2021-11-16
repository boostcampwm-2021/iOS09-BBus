//
//  HomeModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation

struct HomeFavoriteList {

    private var favorites: [HomeFavorite]

    subscript (index: Int) -> HomeFavorite? {
        guard 0..<self.favorites.count ~= index else { return nil }
        return self.favorites[index]
    }

    init(dtoList: [FavoriteItemDTO]) {
        var favorites = [HomeFavorite]()
        dtoList.forEach({ dto in
            if let index = favorites.firstIndex(where: { $0.stationId == dto.stId }) {
                favorites[index].append(newElement: dto)
            }
            else {
                favorites.append(HomeFavorite(stationId: dto.stId,
                                                   arsId: dto.arsId,
                                                   buses: [dto]))
            }
        })
        self.favorites = favorites
    }

    func count() -> Int {
        return self.favorites.count
    }

    mutating func configure(homeArrivalinfo: HomeArriveInfo, indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        self.favorites[section].configure(homeArrivalInfo: homeArrivalinfo, row: row)
    }

    func indexPath(of favoriteItemDTO: FavoriteItemDTO) -> IndexPath? {
        guard let section = self.favorites.firstIndex(where: { $0.stationId == favoriteItemDTO.stId }),
              let row = self.favorites[section].buses.firstIndex(where: { $0.0.busRouteId == favoriteItemDTO.busRouteId})
        else { return nil }

        return IndexPath(row: row, section: section)
    }
}

struct HomeFavorite: Equatable {

    subscript(index: Int) -> (FavoriteItemDTO, HomeArriveInfo?)? {
        guard 0..<self.buses.count ~= index else { return nil }
        return self.buses[index]
    }

    static func == (lhs: HomeFavorite, rhs: HomeFavorite) -> Bool {
        return lhs.stationId == rhs.stationId
    }

    let stationId: String
    let arsId: String
    var buses: [(FavoriteItemDTO, HomeArriveInfo?)]

    init(stationId: String, arsId: String, buses: [FavoriteItemDTO]) {
        self.stationId = stationId
        self.buses = buses.map { ($0, nil) }
        self.arsId = arsId
    }

    mutating func append(newElement: FavoriteItemDTO) {
        self.buses.append((newElement, nil))
    }

    func count() -> Int {
        return self.buses.count
    }

    mutating func configure(homeArrivalInfo: HomeArriveInfo, row: Int) {
        self.buses[row].1 = homeArrivalInfo
    }

}

struct HomeArriveInfo {
    let firstTime: BusRemainTime
    let secondTime: BusRemainTime
    let firstRemainStation: String?
    let secondRemainStation: String?
    let firstBusCongestion: BusCongestion?
    let secondBusCongestion: BusCongestion?

    init(arrInfoByRouteDTO: ArrInfoByRouteDTO) {
        let firstSeperatedTuple = AlarmSettingBusArriveInfo.seperateTimeAndPositionInfo(with: arrInfoByRouteDTO.firstBusArriveRemainTime )
        let secondSeperatedTuple = AlarmSettingBusArriveInfo.seperateTimeAndPositionInfo(with: arrInfoByRouteDTO.secondBusArriveRemainTime)
        self.firstTime = firstSeperatedTuple.time
        self.secondTime = secondSeperatedTuple.time
        self.firstRemainStation = firstSeperatedTuple.position
        self.secondRemainStation = secondSeperatedTuple.position
        self.firstBusCongestion = BusCongestion(rawValue: arrInfoByRouteDTO.firstBusCongestion)
        self.secondBusCongestion = BusCongestion(rawValue: arrInfoByRouteDTO.secondBusCongestion)
    }
}
