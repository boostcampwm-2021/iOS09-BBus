//
//  GetBusPosByRtidFetcher.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

protocol GetBusPosByRtidFetchable {
    func fetch(param: [String: String]) -> AnyPublisher<Data, Error>
}

struct ServiceGetBusPosByRtidFetcher: ServiceFetchable, GetBusPosByRtidFetchable {
    private(set) var tokenManager: TokenManagable
    private(set) var requestFactory: Requestable
    
    func fetch(param: [String : String]) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid"
        return self.fetch(url: url, param: param)
    }
}
