//
//  GetStationListFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/10.
//

import Foundation
import Combine

protocol GetStationListFetchable {
    func fetch(on queue: DispatchQueue) -> AnyPublisher<Data, Error>
}

final class PersistentGetStationListFetcher: GetStationListFetchable {
    func fetch(on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        return Persistent.shared.get(file: "StationList", type: "json", on: queue)
    }
}
