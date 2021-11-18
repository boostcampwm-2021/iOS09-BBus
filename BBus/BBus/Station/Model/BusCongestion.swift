//
//  BusCongestion.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation

enum BusCongestion: Int {
    case relaxed = 3, normal, confusion, veryCrowded
    
    func toString() -> String {
        switch self {
        case .relaxed : return "여유"
        case .normal : return "보통"
        case .confusion : return "혼잡"
        case .veryCrowded : return "매우 혼잡"
        }
    }
}
