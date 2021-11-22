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
    let stationNameMatchRanges: [NSRange]
    let arsIdMatchRanges: [NSRange]
    
    init(stationName: String, arsId: String, stationNameMatchRanges: [Range<String.Index>], arsIdMatchRanges: [Range<String.Index>]) {
        self.stationName = stationName
        self.arsId = arsId
        self.stationNameMatchRanges = stationNameMatchRanges.map { NSRange($0, in: stationName) }
        self.arsIdMatchRanges = arsIdMatchRanges.map { NSRange($0, in: arsId) }
    }
}
