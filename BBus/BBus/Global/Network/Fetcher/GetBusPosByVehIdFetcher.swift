//
//  GetBusPosByVehIdFetcher.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation
import Combine

protocol GetBusPosByVehIdFetchable {
    func fetch(param: [String: String]) -> AnyPublisher<Data, Error>
}

struct ServiceGetBusPosByVehIdFetcher: GetBusPosByVehIdFetchable {
    func fetch(param: [String: String]) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/buspos/getBusPosByVehId"
        return Service.shared.get(url: url, params: param).mapJsonBBusAPIError()
    }
}
