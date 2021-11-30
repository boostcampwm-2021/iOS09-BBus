//
//  AverageSectionTimeCalculatable.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/30.
//

import Foundation

protocol AverageSectionTimeCalculatable: BaseUseCase {
    func averageSectionTime(speed: Int, distance: Int) -> Int
}

extension AverageSectionTimeCalculatable {
    func averageSectionTime(speed: Int, distance: Int) -> Int {
        let averageBusSpeed: Double = 21
        let metterToKilometter: Double = 0.06

        let result = Double(distance)/averageBusSpeed*metterToKilometter
        return Int(ceil(result))
    }
}
