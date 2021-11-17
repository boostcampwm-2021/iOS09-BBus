//
//  NotificationNameExtension.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/16.
//

import Foundation

extension Notification.Name {
    static let oneSecondPassed = Self.init(rawValue: "oneSecondPassed")
    static let thirtySecondPassed = Self.init(rawValue: "thirtySecondPassed")
    static let fifteenSecondsPassed = Self.init(rawValue: "fifteenSecondsPassed")
}
