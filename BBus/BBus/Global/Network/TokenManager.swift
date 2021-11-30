//
//  TokenManager.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation

protocol TokenManagable: AnyObject {
    init()
    func removeAccessKey(at order: Int)
    func randomAccessKey() throws -> (index: Int, key: String)
}

class TokenManager: TokenManagable {
    static let maxTokenCount: Int = 17
    
    private(set) var accessKeys: [String] = { () -> [String] in
        let keys = [Bundle.main.infoDictionary?["API_ACCESS_KEY1"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY2"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY3"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY4"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY5"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY6"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY7"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY8"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY9"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY10"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY11"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY12"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY13"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY14"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY15"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY16"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY17"] as? String]
        return keys.compactMap({ $0 }).filter({ $0 != "" })
    }()
    
    private var keys: [Int]
    
    required init() {
        self.keys = Array(0..<self.accessKeys.count)
    }
    
    func removeAccessKey(at order: Int) {
        self.keys = self.keys.filter({ $0 != order })
    }
    
    func randomAccessKey() throws -> (index: Int, key: String) {
        guard self.keys.count != 0,
              let order = self.keys.randomElement() else {
                  throw BBusAPIError.noMoreAccessKeyError
        }
        return (order, accessKeys[order])
    }
}
