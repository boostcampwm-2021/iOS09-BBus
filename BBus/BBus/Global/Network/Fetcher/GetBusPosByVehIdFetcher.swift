//
//  GetBusPosByVehIdFetcher.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation
import Combine

protocol GetBusPosByVehIdFetchable {
    func fetch(param: [String: String], on queue: DispatchQueue) -> AnyPublisher<Data, Error>
}

final class ServiceGetBusPosByVehIdFetcher: GetBusPosByVehIdFetchable {
    func fetch(param: [String: String], on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/buspos/getBusPosByVehId"
        return Service.shared.get(url: url, params: param, on: queue).mapJsonBBusAPIError()
    }
}
