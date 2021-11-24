//
//  GetStationByUidItemFetcher.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

protocol GetStationByUidItemFetchable {
    func fetch(param: [String: String], on queue: DispatchQueue) -> AnyPublisher<Data, Error>
}

final class ServiceGetStationByUidItemFetcher: GetStationByUidItemFetchable {
    func fetch(param: [String : String], on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid"
        return Service.shared.get(url: url, params: param, on: queue).mapJsonBBusAPIError()
    }
}
