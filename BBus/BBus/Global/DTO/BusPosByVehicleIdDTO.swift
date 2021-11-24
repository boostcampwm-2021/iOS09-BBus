//
//  BusPosByVehicleId.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation

struct JsonHeader: Codable {
    let msgHeader: MessageHeader
}

struct JsonMessage<T: Codable>: Codable {
    let msgHeader: MessageHeader
    let msgBody: MessageBody<T>
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

struct MessageBody<T: Codable>: Codable {
    let itemList: [T]
}

struct BusPosByVehicleIdDTO: Codable {

    let stationOrd: String

    enum CodingKeys: String, CodingKey {
        case stationOrd = "stOrd"
    }
}
