//
//  GetRouteListFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol GetRouteListFetchable {
    func fetch() -> AnyPublisher<Data, Error>
}

struct PersistenceGetRouteListFetcher: PersistenceFetchable, GetRouteListFetchable {
    private(set) var persistenceStorage: PersistenceStorageProtocol
    
    func fetch() -> AnyPublisher<Data, Error> {
        return self.persistenceStorage.get(file: "BusRouteList", type: "json")
            .eraseToAnyPublisher()
    }
}
