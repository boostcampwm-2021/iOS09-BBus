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

struct PersistentGetRouteListFetcher: GetRouteListFetchable {
    func fetch() -> AnyPublisher<Data, Error> {
        return Persistent.shared.get(file: "BusRouteList", type: "json")
            .compactMap({$0})
            .eraseToAnyPublisher()
    }
}
