//
//  StationCalculateUseCase.swift
//  BBus
//
//  Created by 최수정 on 2021/11/30.
//

import Foundation

final class StationCalculateUseCase: StationCalculatable {
    func findStation(in stations: [StationDTO], with arsId: String) -> StationDTO? {
        let station = stations.filter() { $0.arsID == arsId }
        return station.first
    }
}
