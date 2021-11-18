//
//  BusRemainTime.swift
//  BBus
//
//  Created by 이지수 on 2021/11/16.
//

import Foundation

struct BusRemainTime {
    var seconds: Int?
    let message: String?

    init(arriveRemainTime: String) {
        let times = arriveRemainTime.components(separatedBy: ["분", "초"])
        switch times.count {
        case 3 :
            self.seconds = 60 * (Int(times[0]) ?? 0) + (Int(times[1]) ?? 0)
            self.message = nil
        case 2:
            if arriveRemainTime.contains("분") {
                self.seconds = 60 * (Int(times[0]) ?? 0)
            }
            else {
                self.seconds = Int(times[1]) ?? 0
            }
            self.message = nil
        default :
            self.seconds = nil
            self.message = arriveRemainTime
        }
    }
    
    func toString() -> String? {
        if let time = self.seconds {
            let minutes = time / 60
            let seconds = time % 60
            return minutes >= 1 ? "\(minutes)분 \(seconds)초" : "\(max(seconds, 0))초"
        }
        else {
            return self.checkInfo() ? self.message : nil
        }
    }
    
    func estimateArrivalTime() -> Date? {
        guard self.checkInfo() else { return nil }
        guard let seconds = self.seconds else { return Date() }
        return Date(timeIntervalSinceNow: TimeInterval(seconds))
    }
    
    func checkInfo() -> Bool {
        guard let message = self.message else { return true }
        let noInfoMessages = ["운행종료", "출발대기"]
        return !noInfoMessages.contains(message)
    }

    mutating func descend() {
        if let second = self.seconds {
            self.seconds = second - 1
        }
    }
}
