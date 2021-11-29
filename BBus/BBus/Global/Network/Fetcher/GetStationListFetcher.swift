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

struct PersistentGetStationListFetcher: GetStationListFetchable {
    func fetch() -> AnyPublisher<Data, Error> {
        return Persistent.shared.get(file: "StationList", type: "json")
            .compactMap({$0})
            .eraseToAnyPublisher()
    }
}
