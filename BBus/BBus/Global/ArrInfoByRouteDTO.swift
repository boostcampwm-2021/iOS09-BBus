//
//  ArrInfoByRouteListDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/11.
//

import Foundation

struct ArrInfoByRouteDTO: BBusXMLDTO {

    let firstBusArriveRemainTime: String
    let secondBusArriveRemainTime: String
    let firstBusCongestion: String
    let secondBusCongestion: String
    let firstBusCurrentStation: String
    let secondBusCurrentStation: String
    let firstBusPlainNumber: String
    let secondBusPlainNumber: String

    init?(dict: [String : [Any]]) {
        guard let firstBusArriveRemainTime = ((dict["arrmsg1"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let secondBusArriveRemainTime = ((dict["arrmsg2"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let firstBusCongestion = ((dict["reride_Num1"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let secondBusCongestion = ((dict["reride_Num2"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let firstBusCurrentStation = ((dict["stationNm1"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let secondBusCurrentStation = ((dict["stationNm2"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let firstBusPlainNumber = ((dict["plainNo1"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let secondBusPlainNumber = ((dict["plainNo2"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }) else { return nil }
        
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
