//
//  StationsByPosDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/11.
//

import Foundation

struct StationsByPosBody: BBusXMLDTO {
    private let itemList: [StationsByPosDTO?]

    init?(dict: [String : [Any]]) {
        guard let itemList = (dict["itemList"] as? [[String:[Any]]])?.map({ StationsByPosDTO(dict: $0) }),
              let itemListUnwrapped = itemList as? [StationsByPosDTO] else { return nil }

        self.itemList = itemListUnwrapped
    }
}

struct StationsByPosResult: BBusXMLDTO {
    var header: GovernmentMessageHeader
    var body: StationsByPosBody

    init?(dict: [String : [Any]]) {
        guard let headerDict = dict["msgHeader"]?[0] as? [String:[Any]],
              let bodyDict = dict["msgBody"]?[0] as? [String:[Any]],
              let header = GovernmentMessageHeader(dict: headerDict),
              let body = StationsByPosBody(dict: bodyDict) else { return nil }

        self.header = header
        self.body = body
    }
}

struct StationsByPosDTO: BBusXMLDTO {
    
    let stationId: Int
    let stationName: String

    init?(dict: [String : [Any]]) {
        guard let stationIdString = ((dict["stationId"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let stationId = Int(stationIdString),
              let stationName = ((dict["stationNm"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }) else { return nil }
        
        self.stationId = stationId
        self.stationName = stationName
    }
}
