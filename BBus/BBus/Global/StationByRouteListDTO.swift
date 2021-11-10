//
//  RouteInfoItemDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/10.
//

import Foundation

struct StationByRouteListDTO: BBusXMLDTO {
    let sectionSpeed: Int
    let sequence: Int
    let stationName: String
    let fullSectionDistance: Int
    let arsId: String
    
    init?(dict: [String : [Any]]) {
        guard let sectSpdString = ((dict["sectSpd"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let sectSpd = Int(sectSpdString),
              let seqString = ((dict["seq"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let seq = Int(seqString),
              let stationName = ((dict["sectionNm"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let fullSectionDistanceString = ((dict["fullSectDist"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let fullSectionDistance = Int(fullSectionDistanceString),
              let arsId = ((dict["arsId"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }) else { return nil }
        
        self.sectionSpeed = sectSpd
        self.sequence = seq
        self.stationName = stationName
        self.fullSectionDistance = fullSectionDistance
        self.arsId = arsId
    }
}
