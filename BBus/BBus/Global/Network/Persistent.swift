//
//  Persistent.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

struct FavoriteItem: Codable {
    let stId: String
    let busRouteId: String
    let ord: String
}

class Persistent {
    
    enum PersistentError: Error {
        case noneError, decodingError, encodingError
    }
    
    static let shared = Persistent()
    private let favoiteItemsKey = "FavoriteItems"
    
    private init() { }

    func create(param: FavoriteItem) -> Result<FavoriteItem, PersistentError> {
        var items: [FavoriteItem] = []
        if let data = UserDefaults.standard.data(forKey: self.favoiteItemsKey) {
            let decodingItems = (try? PropertyListDecoder().decode([FavoriteItem].self, from: data))
            if let decodingItems = decodingItems {
                items = decodingItems
            } else {
                return .failure(PersistentError.decodingError)
            }
        }
        items.append(param)
        if let data = try? PropertyListEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: self.favoiteItemsKey)
        } else {
            return .failure(PersistentError.encodingError)
        }
        return .success(param)
    }

    func get() -> Result<[FavoriteItem], PersistentError> {
        if let data = UserDefaults.standard.data(forKey: self.favoiteItemsKey) {
            let items = (try? PropertyListDecoder().decode([FavoriteItem].self, from: data))
            if let items = items {
                return .success(items)
            } else {
                return .failure(PersistentError.decodingError)
            }
        }
        return .success([])
    }

    func delete(param: FavoriteItem) -> Result<FavoriteItem, PersistentError> {
        guard let data = UserDefaults.standard.data(forKey: self.favoiteItemsKey) else {
            return .failure(PersistentError.noneError)
        }
        guard var items = (try? PropertyListDecoder().decode([FavoriteItem].self, from: data)) else {
            return .failure(PersistentError.decodingError)
        }
        let count = items.count
        items.removeAll(where: { item in
            item.busRouteId == param.busRouteId && item.ord == param.ord && item.stId == param.stId
        })
        if count == items.count {
            return .failure(PersistentError.noneError)
        }
        if let data = try? PropertyListEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: self.favoiteItemsKey)
        } else {
            return .failure(PersistentError.encodingError)
        }
        return .success(param)
    }
}
