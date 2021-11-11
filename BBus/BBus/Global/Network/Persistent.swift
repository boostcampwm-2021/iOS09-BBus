//
//  Persistent.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

struct FavoriteItem: Codable, Equatable {
    let stId: String
    let busRouteId: String
    let ord: String
    let arsId: String
}

class Persistent {
    
    enum PersistentError: Error {
        case noneError, decodingError, encodingError, urlError
    }
    
    static let shared = Persistent()
    
    private init() { }

    func create<T: Codable>(key: String, param: T, on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        let publisher = PassthroughSubject<Data, Error>()
        queue.async { [weak publisher] in
            var items: [T] = []
            if let data = UserDefaults.standard.data(forKey: key) {
                let decodingItems = (try? PropertyListDecoder().decode([T].self, from: data))
                if let decodingItems = decodingItems {
                    items = decodingItems
                } else {
                    publisher?.send(completion: .failure(PersistentError.decodingError))
                }
            }
            items.append(param)
            if let data = try? PropertyListEncoder().encode(items) {
                UserDefaults.standard.set(data, forKey: key)
            } else {
                publisher?.send(completion: .failure(PersistentError.encodingError))
                return
            }
            if let item = try? PropertyListEncoder().encode(param) {
                publisher?.send(item)
            } else {
                publisher?.send(completion: .failure(PersistentError.encodingError))
            }
        }
        return publisher.eraseToAnyPublisher()
    }

    func getFromUserDefaults(key: String, on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        let publisher = PassthroughSubject<Data, Error>()
        queue.async { [weak publisher] in
            if let data = UserDefaults.standard.data(forKey: key) {
//                print(String(data: data, encoding: .utf8))
                publisher?.send(data)
            } else {
                publisher?.send(completion: .failure(PersistentError.noneError))
            }
        }
        return publisher.eraseToAnyPublisher()
    }
    
    func get(file: String, type: String, on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        let publisher = PassthroughSubject<Data, Error>()
        queue.async { [weak publisher] in
            dump(publisher)
            guard let url = Bundle.main.url(forResource: file, withExtension: type) else {
                publisher?.send(completion: .failure(PersistentError.urlError))
                return
            }
            if let data = try? Data(contentsOf: url) {
                publisher?.send(data)
            } else {
                publisher?.send(completion: .failure(PersistentError.noneError))
            }
        }
        return publisher.eraseToAnyPublisher()
    }

    func delete<T: Codable & Equatable>(key: String, param: T, on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        let publisher = PassthroughSubject<Data, Error>()
        queue.async { [weak publisher] in
            guard let data = UserDefaults.standard.data(forKey: key) else {
                publisher?.send(completion: .failure(PersistentError.noneError))
                return
            }
            guard var items = (try? PropertyListDecoder().decode([T].self, from: data)) else {
                publisher?.send(completion: .failure(PersistentError.decodingError))
                return
            }
            let count = items.count
            items.removeAll() {$0 == param}
            if count == items.count {
                publisher?.send(completion: .failure(PersistentError.noneError))
                return
            }
            if let data = try? PropertyListEncoder().encode(items) {
                UserDefaults.standard.set(data, forKey: key)
                publisher?.send(data)
            } else {
                publisher?.send(completion: .failure(PersistentError.encodingError))
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}

