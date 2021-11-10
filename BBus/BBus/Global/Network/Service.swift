//
//  Service.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation

enum AccessKey {
    case busArrive, routeInfo, stationInfo, busLocation
    
    func toString() -> String? {
        switch self {
        case .busArrive :
            return Bundle.main.infoDictionary?["BUS_ARRIVE_API_ACCESS_KEY"] as? String
        case .busLocation :
            return Bundle.main.infoDictionary?["BUS_ARRIVE_API_ACCESS_KEY"] as? String
        case .routeInfo :
            return Bundle.main.infoDictionary?["BUS_ARRIVE_API_ACCESS_KEY"] as? String
        case .stationInfo :
            return Bundle.main.infoDictionary?["BUS_ARRIVE_API_ACCESS_KEY"] as? String
        }
    }
}

class Service {
    static let shared = Service()
    private init() { }
}
