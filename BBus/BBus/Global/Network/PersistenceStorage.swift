//
//  PersistenceStorage.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

protocol PersistenceStorageProtocol {
    func create<T: Codable>(key: String, param: T) -> AnyPublisher<Data, Error>
    func getFromUserDefaults(key: String) -> AnyPublisher<Data, Error>
    func get(file: String, type: String) -> AnyPublisher<Data, Error>
    func delete<T: Codable & Equatable>(key: String, param: T) -> AnyPublisher<Data, Error>
}

struct PersistenceStorage: PersistenceStorageProtocol {
    
    private enum PersistenceError: Error {
        case noneError, decodingError, encodingError, urlError
    }

    func create<T: Codable>(key: String, param: T) -> AnyPublisher<Data, Error> {
        let publisher = CurrentValueSubject<Data?, Error>(nil)
        DispatchQueue.global().async { [weak publisher] in
            var items: [T] = []
            if let data = UserDefaults.standard.data(forKey: key) {
                let decodingItems = (try? PropertyListDecoder().decode([T].self, from: data))
                if let decodingItems = decodingItems {
                    items = decodingItems
                } else {
                    publisher?.send(completion: .failure(PersistenceError.decodingError))
                }
            }
            items.append(param)
            if let data = try? PropertyListEncoder().encode(items) {
                UserDefaults.standard.set(data, forKey: key)
            } else {
                publisher?.send(completion: .failure(PersistenceError.encodingError))
                return
            }
            if let item = try? PropertyListEncoder().encode(param) {
                publisher?.send(item)
            } else {
                publisher?.send(completion: .failure(PersistenceError.encodingError))
            }
        }
        return publisher.compactMap({$0}).eraseToAnyPublisher()
    }

    func getFromUserDefaults(key: String) -> AnyPublisher<Data, Error> {
        let publisher = CurrentValueSubject<Data?, Error>(nil)
        DispatchQueue.global().async { [weak publisher] in
            if let data = UserDefaults.standard.data(forKey: key) {
                publisher?.send(data)
            } else {
                let emptyFavoriteList = [FavoriteItemDTO]()
                
                if let data = try? PropertyListEncoder().encode(emptyFavoriteList) {
                    publisher?.send(data)
                } else {
                    publisher?.send(completion: .failure(PersistenceError.noneError))
                }
            }
        }
        return publisher.compactMap({$0}).eraseToAnyPublisher()
    }
    
    func get(file: String, type: String) -> AnyPublisher<Data, Error> {
        let publisher = CurrentValueSubject<Data?, Error>(nil)
        DispatchQueue.global().async { [weak publisher] in
            guard let url = Bundle.main.url(forResource: file, withExtension: type) else {
                publisher?.send(completion: .failure(PersistenceError.urlError))
                return
            }
            if let data = try? Data(contentsOf: url) {
                publisher?.send(data)
            } else {
                publisher?.send(completion: .failure(PersistenceError.noneError))
            }
        }
        return publisher.compactMap({$0}).eraseToAnyPublisher()
    }

    func delete<T: Codable & Equatable>(key: String, param: T) -> AnyPublisher<Data, Error> {
        let publisher = CurrentValueSubject<Data?, Error>(nil)
        DispatchQueue.global().async { [weak publisher] in
            guard let data = UserDefaults.standard.data(forKey: key) else {
                publisher?.send(completion: .failure(PersistenceError.noneError))
                return
            }
            guard var items = (try? PropertyListDecoder().decode([T].self, from: data)) else {
                publisher?.send(completion: .failure(PersistenceError.decodingError))
                return
            }
            let count = items.count
            items.removeAll() {$0 == param}
            if count == items.count {
                publisher?.send(completion: .failure(PersistenceError.noneError))
                return
            }
            if let data = try? PropertyListEncoder().encode(items) {
                UserDefaults.standard.set(data, forKey: key)
                publisher?.send(data)
            } else {
                publisher?.send(completion: .failure(PersistenceError.encodingError))
            }
        }
        return publisher.compactMap({$0}).eraseToAnyPublisher()
    }
}

