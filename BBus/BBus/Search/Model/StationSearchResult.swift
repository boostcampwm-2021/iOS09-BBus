//
//  SearchBusModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation

struct StationSearchResult {
    let stationName: String
    let arsId: String
    var stationNameMatchRange: [NSRange]
    var arsIdMatchRange: [NSRange]
}
