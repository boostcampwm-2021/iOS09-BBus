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
        // TODO: - url 주소 지정 필요
        return Persistent.shared.get(file: "fileName", type: "json")
    }
}
