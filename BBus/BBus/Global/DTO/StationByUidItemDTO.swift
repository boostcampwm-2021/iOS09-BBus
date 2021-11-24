//
//  StationByUidItem.swift
//  BBus
//
//  Created by 최수정 on 2021/11/10.
//

import Foundation

// JSON
struct StationByUidItemResult: Codable {
    let msgHeader: MessageHeader
    let msgBody: StationByUidItemBody
}

struct StationByUidItemBody: Codable {
    let itemList: [StationByUidItemDTO]
}

struct StationByUidItemDTO: Codable {
    let firstBusArriveRemainTime: String
    let secondBusArriveRemainTime: String
    let arsId: String
    let stationOrd: Int
    let busRouteId: Int
    let congestion: Int
    let nextStation: String
    let busNumber: String
    let routeType: String

    enum CodingKeys: String, CodingKey {
        case firstBusArriveRemainTime = "arrmsg1"
        case secondBusArriveRemainTime = "arrmsg2"
        case arsId
        case stationOrd = "staOrd"
        case busRouteId
        case congestion
        case nextStation = "nxtStn"
        case busNumber = "rtNm"
        case routeType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstBusArriveRemainTime = (try? container.decode(String.self, forKey: .firstBusArriveRemainTime)) ?? ""
        self.secondBusArriveRemainTime = (try? container.decode(String.self, forKey: .secondBusArriveRemainTime)) ?? ""
        self.arsId = (try? container.decode(String.self, forKey: .arsId)) ?? ""
        self.stationOrd = Int((try? container.decode(String.self, forKey: .stationOrd)) ?? "") ?? 0
        self.busRouteId = Int((try? container.decode(String.self, forKey: .busRouteId)) ?? "") ?? 0
        self.congestion = Int((try? container.decode(String.self, forKey: .congestion)) ?? "") ?? 0
        self.nextStation = (try? container.decode(String.self, forKey: .nextStation)) ?? ""
        self.busNumber = (try? container.decode(String.self, forKey: .busNumber)) ?? ""
        self.routeType = (try? container.decode(String.self, forKey: .routeType)) ?? ""
    }
}
