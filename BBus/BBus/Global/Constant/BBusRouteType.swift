//
//  BBusRouteType.swift
//  BBus
//
//  Created by 최수정 on 2021/11/09.
//

import Foundation

enum BBusRouteType: Int {
    case shared = 0, airport, town, gansun, jisun, circular, wideArea, incheon, gyeonggi, closed
    
    func toString() -> String {
        let common = "버스"
        switch self {
        case .shared: return "공용" + common
        case .airport: return "공항" + common
        case .town: return "마을" + common
        case .gansun: return "간선" + common
        case .jisun: return "지선" + common
        case .circular: return "순환" + common
        case .wideArea: return "광역" + common
        case .incheon: return "인천" + common
        case .gyeonggi: return "경기" + common
        case .closed: return "폐지" + common
        }
    }
}
