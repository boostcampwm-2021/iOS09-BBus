//
//  StationByUidItem.swift
//  BBus
//
//  Created by 최수정 on 2021/11/10.
//

import Foundation

struct StationByUidItemBody: BBusXMLDTO {
    private let itemList: [StationByUidItemDTO]

    init?(dict: [String : [Any]]) {
        guard let itemList = (dict["itemList"] as? [[String:[Any]]])?.map({ StationByUidItemDTO(dict: $0) }),
              let itemListUnwrapped = itemList as? [StationByUidItemDTO] else { return nil }

        self.itemList = itemListUnwrapped
    }
}

struct StationByUidItemResult: BBusXMLDTO {
    var header: GovernmentMessageHeader
    var body: StationByUidItemBody

    init?(dict: [String : [Any]]) {
        guard let headerDict = dict["msgHeader"]?[0] as? [String:[Any]],
              let bodyDict = dict["msgBody"]?[0] as? [String:[Any]],
              let header = GovernmentMessageHeader(dict: headerDict),
              let body = StationByUidItemBody(dict: bodyDict) else { return nil }

        self.header = header
        self.body = body
    }
}

struct StationByUidItemDTO: BBusXMLDTO {
    let firstBusArriveRemainTime: String
    let secondBusArriveRemainTime: String
    let arsId: String
    let busRouteId: Int
    let congestion: Int
    let nextStation: String
    let busNumber: String

    init?(dict: [String : [Any]]) {
        guard let firstBusArrivalRemainTime = ((dict["arrmsg1"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let secondBusArrivalRemainTime = ((dict["arrmsg2"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let arsId = ((dict["arsId"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let busRouteIdString = ((dict["busRouteId"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let busRouteId = Int(busRouteIdString),
              let congestionString = ((dict["congestion"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let congestion = Int(congestionString),
              let nextStation = ((dict["nxtStn"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let busNumber = ((dict["rtNm"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }) else { return nil }

        self.firstBusArriveRemainTime = firstBusArrivalRemainTime
        self.secondBusArriveRemainTime = secondBusArrivalRemainTime
        self.arsId = arsId
        self.busRouteId = busRouteId
        self.congestion = congestion
        self.nextStation = nextStation
        self.busNumber = busNumber
    }
}
