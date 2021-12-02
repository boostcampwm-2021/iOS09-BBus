//
//  JsonDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
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
