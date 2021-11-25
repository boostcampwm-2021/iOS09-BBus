//
//  ArrInfoByRouteDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/11.
//

import Foundation

// JSON
struct ArrInfoByRouteResult: Codable {
    let msgHeader: MessageHeader
    let msgBody: ArrInfoByRouteBody
}

struct ArrInfoByRouteBody: Codable {
    let itemList: [ArrInfoByRouteDTO]
}

struct ArrInfoByRouteDTO: Codable {
    let firstBusArriveRemainTime: String
    let secondBusArriveRemainTime: String
    let firstBusCongestion: Int
    let secondBusCongestion: Int
    let firstBusCurrentStation: String
    let secondBusCurrentStation: String
    let firstBusPlainNumber: String
    let secondBusPlainNumber: String
    let firstBusVehicleId: Int
    let secondBusVehicleId: Int

    enum CodingKeys: String, CodingKey {
        case firstBusArriveRemainTime = "arrmsg1"
        case secondBusArriveRemainTime = "arrmsg2"
        case firstBusCongestion = "reride_Num1"
        case secondBusCongestion = "reride_Num2"
        case firstBusCurrentStation = "stationNm1"
        case secondBusCurrentStation = "stationNm2"
        case firstBusPlainNumber = "plainNo1"
        case secondBusPlainNumber = "plainNo2"
        case firstBusVehicleId = "vehId1"
        case secondBusVehicleId = "vehId2"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstBusArriveRemainTime = (try? container.decode(String.self, forKey: .firstBusArriveRemainTime)) ?? ""
        self.secondBusArriveRemainTime = (try? container.decode(String.self, forKey: .secondBusArriveRemainTime)) ?? ""
        self.firstBusCongestion = Int((try? container.decode(String.self, forKey: .firstBusCongestion)) ?? "") ?? 0
        self.secondBusCongestion = Int((try? container.decode(String.self, forKey: .secondBusCongestion)) ?? "") ?? 0
        self.firstBusCurrentStation = (try? container.decode(String.self, forKey: .firstBusCurrentStation)) ?? ""
        self.secondBusCurrentStation = (try? container.decode(String.self, forKey: .secondBusCurrentStation)) ?? ""
        self.firstBusPlainNumber = (try? container.decode(String.self, forKey: .firstBusPlainNumber)) ?? ""
        self.secondBusPlainNumber = (try? container.decode(String.self, forKey: .secondBusPlainNumber)) ?? ""
        self.firstBusVehicleId = Int((try? container.decode(String.self, forKey: .firstBusVehicleId)) ?? "") ?? 0
        self.secondBusVehicleId = Int((try? container.decode(String.self, forKey: .secondBusVehicleId)) ?? "") ?? 0
    }
}
