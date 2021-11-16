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

    func toRouteType() -> RouteType? {
        switch self {
        case .shared: return RouteType.customized
        case .airport: return RouteType.mainLine
        case .town: return RouteType.customized
        case .gansun: return RouteType.mainLine
        case .jisun: return RouteType.localLine
        case .circular: return RouteType.circulation
        case .wideArea: return RouteType.broadArea
        case .incheon: return nil
        case .gyeonggi: return nil
        case .closed: return nil
        }
    }
}
