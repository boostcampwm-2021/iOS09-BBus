//
//  GetArrInfoByRouteListFetcher.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

protocol GetArrInfoByRouteListFetchable {
    func fetch(param: [String: String]) -> AnyPublisher<Data, Error>
}

struct ServiceGetArrInfoByRouteListFetcher: ServiceFetchable, GetArrInfoByRouteListFetchable {
    private(set) var networkService: NetworkServiceProtocol
    private(set) var tokenManager: TokenManagable
    private(set) var requestFactory: Requestable.Type
    
    func fetch(param: [String: String]) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRoute"
        return self.fetch(url: url, param: param)
    }
}
