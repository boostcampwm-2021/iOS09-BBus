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

struct ServiceGetBusPosByVehIdFetcher: ServiceFetchable, GetBusPosByVehIdFetchable {
    private(set) var networkService: NetworkServiceProtocol
    private(set) var tokenManager: TokenManagable
    private(set) var requestFactory: Requestable.Type
    
    func fetch(param: [String: String]) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/buspos/getBusPosByVehId"
        return self.fetch(url: url, param: param)
    }
}
