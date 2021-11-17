//
//  BusPosByRtid.swift
//  BBus
//
//  Created by 최수정 on 2021/11/10.
//

import Foundation

struct BusPosByRtidBody: BBusXMLDTO {
    let itemList: [BusPosByRtidDTO]

    init?(dict: [String : [Any]]) {
        guard let itemList = (dict["itemList"] as? [[String:[Any]]])?.map({ BusPosByRtidDTO(dict: $0) }),
              let itemListUnwrapped = itemList as? [BusPosByRtidDTO] else { return nil }

        self.itemList = itemListUnwrapped
    }
}

struct BusPosByRtidResult: BBusXMLDTO {
    var header: GovernmentMessageHeader
    var body: BusPosByRtidBody

    init?(dict: [String : [Any]]) {
        guard let headerDict = dict["msgHeader"]?[0] as? [String:[Any]],
              let bodyDict = dict["msgBody"]?[0] as? [String:[Any]],
              let header = GovernmentMessageHeader(dict: headerDict),
              let body = BusPosByRtidBody(dict: bodyDict) else { return nil }

        self.header = header
        self.body = body
    }
}

struct BusPosByRtidDTO: BBusXMLDTO {
    let busType: Int
    let congestion: Int
    let plainNumber: String
    let sectionOrder: Int
    let fullSectDist: String
    let sectDist: String
    let gpsY: String
    let gpsX: String
    
    init?(dict: [String : [Any]]) {
        guard let busTypeString = ((dict["busType"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let busType = Int(busTypeString),
              let congestionString = ((dict["congetion"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let congestion = Int(congestionString),
              let plainNumber = ((dict["plainNo"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let sectOrd = ((dict["sectOrd"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let sectionOrder = Int(sectOrd),
              let fullSectDist = ((dict["fullSectDist"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let sectDist = ((dict["sectDist"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let gpsY = ((dict["gpsY"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1}),
              let gpsX = ((dict["gpsX"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1}) else { return nil }
        
        self.busType = busType
        self.congestion = congestion
        self.plainNumber = plainNumber
        self.sectionOrder = sectionOrder
        self.fullSectDist = fullSectDist
        self.sectDist = sectDist
        self.gpsY = gpsY
        self.gpsX = gpsX
    }
}
