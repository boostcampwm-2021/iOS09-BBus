//
//  BusPosByRtidDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/10.
//

import Foundation

// JSON
struct BusPosByRtidResult: Codable {
    let msgHeader: MessageHeader
    let msgBody: BusPosByRtidBody
}

struct BusPosByRtidBody: Codable {
    let itemList: [BusPosByRtidDTO]
}

struct BusPosByRtidDTO: Codable {
    let busType: Int
    let congestion: Int
    let plainNumber: String
    let sectionOrder: Int
    let fullSectDist: String
    let sectDist: String
    let gpsY: Double
    let gpsX: Double

    enum CodingKeys: String, CodingKey {
        case busType
        case congestion
        case plainNumber = "plainNo"
        case sectionOrder = "sectOrd"
        case fullSectDist
        case sectDist
        case gpsY
        case gpsX
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.busType = Int((try? container.decode(String.self, forKey: .busType)) ?? "") ?? 0
        self.congestion = Int((try? container.decode(String.self, forKey: .congestion)) ?? "") ?? 0
        self.plainNumber = (try? container.decode(String.self, forKey: .plainNumber)) ?? ""
        self.sectionOrder = Int((try? container.decode(String.self, forKey: .sectionOrder)) ?? "") ?? 0
        self.fullSectDist = (try? container.decode(String.self, forKey: .fullSectDist)) ?? ""
        self.sectDist = (try? container.decode(String.self, forKey: .sectDist)) ?? ""
        self.gpsY = Double((try? container.decode(String.self, forKey: .gpsY)) ?? "") ?? 0
        self.gpsX = Double((try? container.decode(String.self, forKey: .gpsX)) ?? "") ?? 0
    }
}
