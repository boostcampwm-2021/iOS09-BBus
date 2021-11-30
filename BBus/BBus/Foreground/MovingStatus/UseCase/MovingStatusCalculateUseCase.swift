//
//  MovingStatusCalculateUseCase.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/29.
//

import Foundation
import Combine
import CoreLocation

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

final class MovingStatusCalculateUseCase: MovingStatusCalculatable {

    func filteredBuses(from buses: [BusPosByRtidDTO], startOrd: Int, currentOrd: Int, count: Int) -> [BusPosByRtidDTO] {
        print(buses)
        print(startOrd)
        print(currentOrd)
        print(count)
        return buses.filter { $0.sectionOrder >= currentOrd && $0.sectionOrder < startOrd + count }
    }
    
    func convertBusInfo(header: BusRouteDTO) -> BusInfo {
        let busInfo: BusInfo
        busInfo.busName = header.busRouteName
        busInfo.type = header.routeType
        
        return busInfo
    }
    
    func remainStation(bus: BusPosByRtidDTO, startOrd: Int, count: Int) -> Int {
        return (count - 1) - (bus.sectionOrder - startOrd)
    }
    
    func pushAlarmMessage(remainStation: Int) -> (message: String?, terminated: Bool) {
        if remainStation < 4 && remainStation > 1 {
            return ("\(remainStation) 정거장 남았어요!", false)
        }
        else if remainStation == 1 {
            return ("다음 정거장에 내려야 합니다!", false)
        }
        else if remainStation <= 0 {
            return ("하차 정거장에 도착하여 알림이 종료되었습니다.", true)
        }
        else {
            return (nil, false)
        }
    }
    
    func remainTime(bus: BusPosByRtidDTO, stations: [StationInfo], startOrd: Int, boardedBus: BoardedBus) -> Int {
        let currentIdx = (bus.sectionOrder - startOrd)
        var totalRemainTime = 0
        
        for index in currentIdx...stations.count-1 {
            totalRemainTime += stations[index].sectTime
        }
        
        let currentLocation = boardedBus.location
        let extraPersent = Double(currentLocation) - Double(currentIdx)
        let extraTime = extraPersent * Double(stations[currentIdx].sectTime)
        
        return totalRemainTime - Int(ceil(extraTime))
    }
    
    func convertBusPos(startOrd: Int, order: Int, sect: String, fullSect: String) -> Double {
        let order = Double(order - startOrd)
        let sect = Double((sect as NSString).floatValue)
        let fullSect = Double((fullSect as NSString).floatValue)

        return order + (sect/fullSect)
    }
    
    func isOnBoard(gpsY: Double, gpsX: Double, busY: Double, busX: Double) -> Bool {
        let userLocation = CLLocation(latitude: gpsX, longitude: gpsY)
        let busLocation = CLLocation(latitude: busX, longitude: busY)
        let distanceInMeters = userLocation.distance(from: busLocation)
        
        return distanceInMeters <= 100.0
    }
    
    func stationIndex(with targetId: String, with stations: [StationByRouteListDTO]) -> Int? {
        return stations.firstIndex(where: { $0.arsId == targetId })
    }
    
    func filteredStations(from stations: [StationByRouteListDTO]) -> (stations: [StationInfo], time: Int) {
        var resultStations: [StationInfo] = []
        var totalTime: Int = 0
        
        for (idx, station) in stations.enumerated() {
            let info: StationInfo
            info.speed = station.sectionSpeed
            info.afterSpeed = idx+1 == stations.count ? nil : stations[idx+1].sectionSpeed
            info.count = stations.count
            info.title = station.stationName
            info.sectTime = idx == 0 ? 0 : self.averageSectionTime(speed: info.speed, distance: station.fullSectionDistance)
            
            resultStations.append(info)
            totalTime += info.sectTime
        }
        
        return (resultStations, totalTime)
    }
}
