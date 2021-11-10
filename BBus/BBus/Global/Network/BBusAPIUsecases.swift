//
//  BBusAPIUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

class BBusAPIUsecases: RequestUsecases {
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        let param = ["stId": stId, "busRouteId": busRouteId, "ord": ord]
        let fetcher: GetArrInfoByRouteListFetchable = ServiceGetArrInfoByRouteListFetcher()
        return fetcher.fetch(param: param)
    }

    func getArrInfoItem(param: [String : String]) {

    }

    func getArrInfo(key: String, param: [String : String]) {

    }

    func createFavoriteItem(key: String, param: [String : String]) {

    }

    func deleteFavoriteItem(key: String) {
        
    }
}
