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
        dtoList.forEach({ favoriteDTO in
            if let index = favorites.firstIndex(where: { $0.stationId == favoriteDTO.stId }) {
                favorites[index].append(newElement: favoriteDTO)
            }
            else {
                favorites.append(HomeFavorite(stationId: favoriteDTO.stId,
                                                   arsId: favoriteDTO.arsId,
                                                   buses: [favoriteDTO]))
            }
        })
        self.favorites = favorites
    }

    func count() -> Int {
        return self.favorites.count
    }

    mutating func configure(homeArrivalinfo: HomeArriveInfo, indexPath: IndexPath) {
        let section = indexPath.section
        let item = indexPath.item
        self.favorites[section].configure(homeArrivalInfo: homeArrivalinfo, item: item)
    }

    func indexPath(of favoriteItemDTO: FavoriteItemDTO) -> IndexPath? {
        guard let section = self.favorites.firstIndex(where: { $0.stationId == favoriteItemDTO.stId }),
              let row = self.favorites[section].buses.firstIndex(where: { $0.0.busRouteId == favoriteItemDTO.busRouteId})
        else { return nil }

        return IndexPath(row: row, section: section)
    }

    mutating func descendAllTime() {
        self.favorites = self.favorites.map({
            var favorite = $0
            favorite.descendTime()
            return favorite
        })
    }
}

struct HomeFavorite: Equatable {

    typealias HomeBusInfo = (favoriteItem: FavoriteItemDTO, arriveInfo: HomeArriveInfo?)

    subscript(index: Int) -> HomeBusInfo? {
        guard 0..<self.buses.count ~= index else { return nil }
        return self.buses[index]
    }

    static func == (lhs: HomeFavorite, rhs: HomeFavorite) -> Bool {
        return lhs.stationId == rhs.stationId
    }

    let stationId: String
    let arsId: String
    var buses: [HomeBusInfo]

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

    mutating func configure(homeArrivalInfo: HomeArriveInfo, item: Int) {
        self.buses[item].arriveInfo = homeArrivalInfo
    }

    mutating func descendTime() {
        self.buses = self.buses.map({
            guard var arriveInfo = $0.arriveInfo else { return ($0.favoriteItem, nil) }
            arriveInfo.descend()
            return ($0.favoriteItem, arriveInfo)
        })
    }
}

struct HomeArriveInfo {
    var firstTime: BusRemainTime
    var secondTime: BusRemainTime
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

    mutating func descend() {
        self.firstTime.descend()
        self.secondTime.descend()
    }
}
