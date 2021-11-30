//
//  StationCalculatable.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
//

import Foundation

protocol StationCalculatable: BaseUseCase {
    func findStation(in stations: [StationDTO], with arsId: String) -> StationDTO?
}
