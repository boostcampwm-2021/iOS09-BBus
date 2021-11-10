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

class PersistentGetRouteListFetcher: GetRouteListFetchable {
    func fetch() -> AnyPublisher<Data, Error> {
        return Persistent.shared.get(url: "")
    }
}
