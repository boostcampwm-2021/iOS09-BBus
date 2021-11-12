//
//  GetStationsByRouteListFetcher.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

protocol GetStationsByRouteListFetchable {
    func fetch(param: [String: String], on queue: DispatchQueue) -> AnyPublisher<Data, Error>
}

class ServiceGetStationsByRouteListFetcher: GetStationsByRouteListFetchable {
    func fetch(param: [String : String], on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/busRouteInfo/getStaionByRoute"
        return Service.shared.get(url: url, params: param, on: queue)
    }
}
