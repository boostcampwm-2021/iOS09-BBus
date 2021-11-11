//
//  GetStationsByPosListFetcher.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

protocol GetStationsByPosListFetchable {
    func fetch(param: [String: String]) -> AnyPublisher<Data, Error>
}

class ServiceGetStationsByPosListFetcher: GetStationsByPosListFetchable {
    func fetch(param: [String : String]) -> AnyPublisher<Data, Error> {
        let url = "http://ws.bus.go.kr/api/rest/stationinfo/getStationByPos"
        return Service.shared.get(url: url, params: param)
    }
}
