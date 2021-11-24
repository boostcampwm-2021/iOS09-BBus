//
//  StationByRouteListDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/10.
//

import Foundation

// JSON
struct StationByRouteResult: Codable {
    let msgHeader: MessageHeader
    let msgBody: StationByRouteBody
}

struct StationByRouteBody: Codable {
    let itemList: [StationByRouteListRawDTO]
}

struct StationByRouteListRawDTO: Codable {
    let sectionSpeed: String //Int -> String 수정
    let sequence: String //Int -> String 수정
    let stationName: String
    let fullSectionDistance: String //Int -> String 수정
    let arsId: String
    let beginTm: String
    let lastTm: String
    let transYn: String

    enum CodingKeys: String, CodingKey {
        case sectionSpeed = "sectSpd"
        case sequence = "seq"
        case stationName = "stationNm"
        case fullSectionDistance = "fullSectDist"
        case arsId = "arsId"
        case beginTm = "beginTm"
        case lastTm = "lastTm"
        case transYn = "transYn"
    }
}

struct StationByRouteListDTO {
    let sectionSpeed: Int
    let sequence: Int
    let stationName: String
    let fullSectionDistance: Int
    let arsId: String
    let beginTm: String
    let lastTm: String
    let transYn: String

    init(rawDto: StationByRouteListRawDTO) {
        self.sectionSpeed = Int(rawDto.sectionSpeed) ?? 0
        self.sequence = Int(rawDto.sequence) ?? 0
        self.stationName = rawDto.stationName
        self.fullSectionDistance = Int(rawDto.fullSectionDistance) ?? 0
        self.arsId = rawDto.arsId
        self.beginTm = rawDto.beginTm
        self.lastTm = rawDto.lastTm
        self.transYn = rawDto.transYn
    }
}
