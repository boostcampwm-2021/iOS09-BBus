//
//  BusPosByVehicleId.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation

struct Welcome: Codable {
    let msgHeader: MsgHeader
    let msgBody: MsgBody
}

// MARK: - MsgHeader
struct MsgHeader: Codable {
    let headerMsg, headerCD: String
    let itemCount: Int

    enum CodingKeys: String, CodingKey {
        case headerMsg
        case headerCD = "headerCd"
        case itemCount
    }
}

// MARK: - MsgBody
struct MsgBody: Codable {
    let itemList: [BusPosByVehicleIdDTO]
}

struct BusPosByVehicleIdDTO: Codable {

    let stationOrd: String

    enum CodingKeys: String, CodingKey {
        case stationOrd = "stOrd"
    }
}
