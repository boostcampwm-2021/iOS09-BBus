//
//  GetRouteInfoItemFetcher.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

protocol GetRouteInfoItemFetchable {
    func fetch(param: [String: String]) -> AnyPublisher<Data, Error>
}

struct ServiceGetRouteInfoItemFetcher: GetRouteInfoItemFetchable {
    func fetch(param: [String : String]) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/busRouteInfo/getRouteInfo"
        return Service.shared.get(url: url, params: param).mapJsonBBusAPIError()
    }
}
