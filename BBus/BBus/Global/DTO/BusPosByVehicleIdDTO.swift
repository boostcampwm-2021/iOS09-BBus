//
//  BusPosByVehicleId.swift
//  BBus
//
//  Created by κΉνν on 2021/11/22.
//

import Foundation

struct BusPosByVehicleIdDTO: Codable {

    let stationOrd: String

    enum CodingKeys: String, CodingKey {
        case stationOrd = "stOrd"
    }
}
