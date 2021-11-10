//
//  BusPosByRtid.swift
//  BBus
//
//  Created by 최수정 on 2021/11/10.
//

import Foundation

struct BusPosByRtidDTO: BBusXMLDTO {
    let busType: Int
    let congestion: Int
    let plainNumber: String
    let sectionOrder: Int
    
    init?(dict: [String : [Any]]) {
        guard let busTypeString = ((dict["busType"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let busType = Int(busTypeString),
              let congestionString = ((dict["congetion"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let congestion = Int(congestionString),
              let plainNumber = ((dict["plainNo"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let sectOrd = ((dict["sectOrd"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let sectionOrder = Int(sectOrd) else { return nil }
        
        self.busType = busType
        self.congestion = congestion
        self.plainNumber = plainNumber
        self.sectionOrder = sectionOrder
    }
}
