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
    let itemList: [StationByRouteListDTO]
}

struct StationByRouteListDTO: Codable {
    let sectionSpeed: Int
    let sequence: Int
    let stationName: String
    let fullSectionDistance: Int
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sectionSpeed = Int((try? container.decode(String.self, forKey: .sectionSpeed)) ?? "") ?? 0
        self.sequence = Int((try? container.decode(String.self, forKey: .sequence)) ?? "") ?? 0
        self.stationName = (try? container.decode(String.self, forKey: .stationName)) ?? ""
        self.fullSectionDistance = Int((try? container.decode(String.self, forKey: .fullSectionDistance)) ?? "") ?? 0
        self.arsId = (try? container.decode(String.self, forKey: .arsId)) ?? ""
        self.beginTm = (try? container.decode(String.self, forKey: .beginTm)) ?? ""
        self.lastTm = (try? container.decode(String.self, forKey: .lastTm)) ?? ""
        self.transYn = (try? container.decode(String.self, forKey: .transYn)) ?? ""
    }
}
