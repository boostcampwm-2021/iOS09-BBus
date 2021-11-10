//
//  StationsByPosDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/11.
//

import Foundation

struct StationsByPosDTO: BBusXMLDTO {
    
    let stationId: Int
    let stationName: String

    init?(dict: [String : [Any]]) {
        guard let stationIdString = ((dict["stationId"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let stationId = Int(stationIdString),
              let stationName = ((dict["stationNm"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }) else { return nil }
        
        self.stationId = stationId
        self.stationName = stationName
    }
}
