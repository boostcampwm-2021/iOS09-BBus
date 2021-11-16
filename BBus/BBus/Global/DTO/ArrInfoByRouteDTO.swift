//
//  ArrInfoByRouteListDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/11.
//

import Foundation

struct ArrInfoByRouteBody: BBusXMLDTO {
    let itemList: [ArrInfoByRouteDTO]

    init?(dict: [String : [Any]]) {
        guard let itemList = (dict["itemList"] as? [[String:[Any]]])?.map({ ArrInfoByRouteDTO(dict: $0) }),
              let itemListUnwrapped = itemList as? [ArrInfoByRouteDTO] else { return nil }

        self.itemList = itemListUnwrapped
    }
}

struct ArrInfoByRouteResult: BBusXMLDTO {
    var header: GovernmentMessageHeader
    var body: ArrInfoByRouteBody

    init?(dict: [String : [Any]]) {
        guard let headerDict = dict["msgHeader"]?[0] as? [String:[Any]],
              let bodyDict = dict["msgBody"]?[0] as? [String:[Any]],
              let header = GovernmentMessageHeader(dict: headerDict),
              let body = ArrInfoByRouteBody(dict: bodyDict) else { return nil }

        self.header = header
        self.body = body
    }
}

struct ArrInfoByRouteDTO: BBusXMLDTO {
    
    let firstBusArriveRemainTime: String
    let secondBusArriveRemainTime: String
    let firstBusCongestion: Int
    let secondBusCongestion: Int
    let firstBusCurrentStation: String
    let secondBusCurrentStation: String
    let firstBusPlainNumber: String
    let secondBusPlainNumber: String

    init?(dict: [String : [Any]]) {
        guard let firstBusArriveRemainTime = ((dict["arrmsg1"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let secondBusArriveRemainTime = ((dict["arrmsg2"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let firstBusCongestionString = ((dict["reride_Num1"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let firstBusCongestion = Int(firstBusCongestionString),
              let secondBusCongestionString = ((dict["reride_Num2"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let secondBusCongestion = Int(secondBusCongestionString),
              let firstBusCurrentStation = ((dict["stationNm1"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let secondBusCurrentStation = ((dict["stationNm2"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let firstBusPlainNumber = ((dict["plainNo1"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let secondBusPlainNumber = ((dict["plainNo2"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }) else { return nil }
        
        self.firstBusArriveRemainTime = firstBusArriveRemainTime
        self.secondBusArriveRemainTime = secondBusArriveRemainTime
        self.firstBusCongestion = firstBusCongestion
        self.secondBusCongestion = secondBusCongestion
        self.firstBusCurrentStation = firstBusCurrentStation
        self.secondBusCurrentStation = secondBusCurrentStation
        self.firstBusPlainNumber = firstBusPlainNumber
        self.secondBusPlainNumber = secondBusPlainNumber
    }
}
