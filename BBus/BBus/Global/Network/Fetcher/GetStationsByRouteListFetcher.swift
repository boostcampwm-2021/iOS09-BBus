//
//  GetStationsByRouteListFetcher.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

protocol GetStationsByRouteListFetchable {
    func fetch(param: [String: String]) -> AnyPublisher<Data, Error>
}

struct ServiceGetStationsByRouteListFetcher: ServiceFetchable, GetStationsByRouteListFetchable {
    private(set) var networkService: NetworkServiceProtocol
    private(set) var tokenManager: TokenManagable
    private(set) var requestFactory: Requestable.Type
    
    func fetch(param: [String : String]) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/busRouteInfo/getStaionByRoute"
        return self.fetch(url: url, param: param)
    }
}
