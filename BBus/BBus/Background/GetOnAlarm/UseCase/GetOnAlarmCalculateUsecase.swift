//
//  BusApproachCheckUsecase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation

protocol GetOnAlarmCalculatable: BaseUseCase {
    func busApproachStatus(currentOrd: Int, beforeOrd: Int, targetOrd: Int) -> BusApproachStatus?
}

struct GetOnAlarmCalculateUsecase: GetOnAlarmCalculatable {

    func busApproachStatus(currentOrd: Int, beforeOrd: Int, targetOrd: Int) -> BusApproachStatus? {
        guard currentOrd != beforeOrd else { return nil }
        return BusApproachStatus(rawValue: targetOrd - currentOrd)
    }
}
