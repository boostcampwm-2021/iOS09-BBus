//
//  AlarmSettingBusArriveInfo.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation

struct AlarmSettingBusArriveInfo {
    static let estimatedTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh시 mm분 도착 예정"
        return formatter
    }()
    
    let arriveRemainTime: BusRemainTime?
    let estimatedArrivalTime: String?
    let relativePosition: String?
    let congestion: BusCongestion?
    let currentStation: String
    let plainNumber: String
    
    init(busArriveRemainTime: String, congestion: Int, currentStation: String, plainNumber: String) {
        let timeAndPositionInfo = Self.seperateTimeAndPositionInfo(with: busArriveRemainTime)
        self.arriveRemainTime = timeAndPositionInfo.time.checkInfo() ? timeAndPositionInfo.time : nil
        self.relativePosition = timeAndPositionInfo.position
        self.congestion = BusCongestion(rawValue: congestion)
        self.currentStation = currentStation
        self.plainNumber = plainNumber
        
        if let estimatedTime = timeAndPositionInfo.time.estimateArrivalTime() {
            self.estimatedArrivalTime = Self.estimatedTimeFormatter.string(from: estimatedTime)
        }
        else {
            self.estimatedArrivalTime = nil
        }
        
    }
    
    static func seperateTimeAndPositionInfo(with info: String) -> (time: BusRemainTime, position: String?) {
        let components = info.components(separatedBy: ["[", "]"])
        if components.count > 1 {
            return (time: BusRemainTime(arriveRemainTime: components[0]), position: components[1])
        }
        else {
            return (time: BusRemainTime(arriveRemainTime: components[0]), position: nil)
        }
    }
}
