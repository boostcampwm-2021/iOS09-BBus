//
//  BusPosByVehicleId.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation

struct JsonMessage: Codable {
    let msgHeader: MessageHeader
    let msgBody: MessageBody
}

struct MessageHeader: Codable {
    let headerMessage, headerCD: String
    let itemCount: Int

    enum CodingKeys: String, CodingKey {
        case headerMessage = "headerMsg"
        case headerCD = "headerCd"
        case itemCount
    }
}

struct MessageBody: Codable {
    let itemList: [BusPosByVehicleIdDTO]
}

struct BusPosByVehicleIdDTO: Codable {

    let stationOrd: String

    enum CodingKeys: String, CodingKey {
        case stationOrd = "stOrd"
    }
}
