//
//  MovingStatusCalculatable.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
//

import Foundation

protocol MovingStatusCalculatable: AverageSectionTimeCalculatable {
    func filteredBuses(from buses: [BusPosByRtidDTO], startOrd: Int, currentOrd: Int, count: Int) -> [BusPosByRtidDTO]
    func convertBusInfo(header: BusRouteDTO) -> BusInfo
    func remainStation(bus: BusPosByRtidDTO, startOrd: Int, count: Int) -> Int
    func pushAlarmMessage(remainStation: Int) -> (message: String?, terminated: Bool)
    func remainTime(bus: BusPosByRtidDTO, stations: [StationInfo], startOrd: Int, boardedBus: BoardedBus) -> Int
    func convertBusPos(startOrd: Int, order: Int, sect: String, fullSect: String) -> Double
    func isOnBoard(gpsY: Double, gpsX: Double, busY: Double, busX: Double) -> Bool
    func stationIndex(with targetId: String, with stations: [StationByRouteListDTO]) -> Int?
    func filteredStations(from stations: [StationByRouteListDTO]) -> (stations: [StationInfo], time: Int)
}
