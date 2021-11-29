//
//  GetStationListFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol GetStationListFetchable {
    func fetch() -> AnyPublisher<Data, Error>
}

struct PersistenceGetStationListFetcher: PersistenceFetchable, GetStationListFetchable {
    private(set) var persistenceStorage: PersistenceStorageProtocol
    
    func fetch() -> AnyPublisher<Data, Error> {
        return self.persistenceStorage.get(file: "StationList", type: "json")
            .eraseToAnyPublisher()
    }
}
