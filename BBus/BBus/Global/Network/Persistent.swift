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

    func create(param: FavoriteItem) -> AnyPublisher<FavoriteItem, PersistentError> {
        let publisher = PassthroughSubject<FavoriteItem, PersistentError>()
        DispatchQueue.global().async { [weak publisher] in
            var items: [FavoriteItem] = []
            if let data = UserDefaults.standard.data(forKey: self.favoiteItemsKey) {
                let decodingItems = (try? PropertyListDecoder().decode([FavoriteItem].self, from: data))
                if let decodingItems = decodingItems {
                    items = decodingItems
                } else {
                    publisher?.send(completion: .failure(PersistentError.decodingError))
                }
            }
            items.append(param)
            if let data = try? PropertyListEncoder().encode(items) {
                UserDefaults.standard.set(data, forKey: self.favoiteItemsKey)
            } else {
                publisher?.send(completion: .failure(PersistentError.encodingError))
            }
            publisher?.send(param)
        }
        return publisher.eraseToAnyPublisher()
    }

    func get() -> AnyPublisher<[FavoriteItem], PersistentError> {
        let publisher = PassthroughSubject<[FavoriteItem], PersistentError>()
        DispatchQueue.global().async { [weak publisher] in
            if let data = UserDefaults.standard.data(forKey: self.favoiteItemsKey) {
                let items = (try? PropertyListDecoder().decode([FavoriteItem].self, from: data))
                if let items = items {
                    publisher?.send(items)
                } else {
                    publisher?.send(completion: .failure(PersistentError.decodingError))
                }
            }
            publisher?.send([])
        }
        return publisher.eraseToAnyPublisher()
    }

    func delete(param: FavoriteItem) -> AnyPublisher<FavoriteItem, PersistentError> {
        let publisher = PassthroughSubject<FavoriteItem, PersistentError>()
        DispatchQueue.global().async { [weak publisher] in
            guard let data = UserDefaults.standard.data(forKey: self.favoiteItemsKey) else {
                publisher?.send(completion: .failure(PersistentError.noneError))
                return
            }
            guard var items = (try? PropertyListDecoder().decode([FavoriteItem].self, from: data)) else {
                publisher?.send(completion: .failure(PersistentError.decodingError))
                return
            }
            let count = items.count
            items.removeAll(where: { item in
                item.busRouteId == param.busRouteId && item.ord == param.ord && item.stId == param.stId
            })
            if count == items.count {
                publisher?.send(completion: .failure(PersistentError.noneError))
                return
            }
            if let data = try? PropertyListEncoder().encode(items) {
                UserDefaults.standard.set(data, forKey: self.favoiteItemsKey)
            } else {
                publisher?.send(completion: .failure(PersistentError.encodingError))
                return
            }
            publisher?.send(param)
        }
        return publisher.eraseToAnyPublisher()
    }
}

