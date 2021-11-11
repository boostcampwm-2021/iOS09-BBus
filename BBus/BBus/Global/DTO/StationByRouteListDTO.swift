//
//  RouteInfoItemDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/10.
//

import Foundation

struct StationByRouteBody: BBusXMLDTO {
    let itemList: [StationByRouteListDTO]

    init?(dict: [String : [Any]]) {
        guard let itemList = (dict["itemList"] as? [[String:[Any]]])?.map({ StationByRouteListDTO(dict: $0) }),
              let itemListUnwrapped = itemList as? [StationByRouteListDTO] else { return nil }

        self.itemList = itemListUnwrapped
    }
}

struct StationByRouteResult: BBusXMLDTO {
    var header: GovernmentMessageHeader
    var body: StationByRouteBody

    init?(dict: [String : [Any]]) {
        guard let headerDict = dict["msgHeader"]?[0] as? [String:[Any]],
              let bodyDict = dict["msgBody"]?[0] as? [String:[Any]],
              let header = GovernmentMessageHeader(dict: headerDict),
              let body = StationByRouteBody(dict: bodyDict) else { return nil }

        self.header = header
        self.body = body
    }
}

struct StationByRouteListDTO: BBusXMLDTO {
    let sectionSpeed: Int
    let sequence: Int
    let stationName: String
    let fullSectionDistance: Int
    let arsId: String
    let beginTm: String
    
    init?(dict: [String : [Any]]) {
        guard let sectSpdString = ((dict["sectSpd"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let sectSpd = Int(sectSpdString),
              let seqString = ((dict["seq"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let seq = Int(seqString),
              let stationName = ((dict["stationNm"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let fullSectionDistanceString = ((dict["fullSectDist"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let fullSectionDistance = Int(fullSectionDistanceString),
              let arsId = ((dict["arsId"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let beginTm = ((dict["beginTm"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1}) else { return nil }
        
        self.sectionSpeed = sectSpd
        self.sequence = seq
        self.stationName = stationName
        self.fullSectionDistance = fullSectionDistance
        self.arsId = arsId
        self.beginTm = beginTm
    }
}
