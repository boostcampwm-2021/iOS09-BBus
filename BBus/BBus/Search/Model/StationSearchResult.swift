//
//  SearchBusModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation

struct StationSearchResult {
    let stationDTO: StationDTO
    var arsIdMatchRange: [Range<String.Index>]
    var stationNameMatchRange: [Range<String.Index>]
}
