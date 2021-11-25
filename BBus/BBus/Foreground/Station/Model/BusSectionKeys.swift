//
//  BusSectionKeys.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/25.
//

import Foundation

struct BusSectionKeys {

    private var keys: [BBusRouteType]

    subscript(section: Int) -> BBusRouteType? {
        guard 0..<self.keys.count ~= section else { return nil }
        return self.keys[section]
    }

    static func +(lhs: BusSectionKeys, rhs: BusSectionKeys) -> BusSectionKeys {
        return Self.init(keys: lhs.keys + rhs.keys)
    }

    init(keys: [BBusRouteType] = []) {
        self.keys = keys
    }

    func count() -> Int {
        return self.keys.count
    }
}
