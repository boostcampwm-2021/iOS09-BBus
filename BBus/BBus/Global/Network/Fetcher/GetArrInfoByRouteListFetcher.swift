//
//  GetArrInfoByRouteListFetcher.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation

protocol Fetchable {
    func fetch()
}

protocol GetArrInfoByRouteListFetchable: Fetchable { }

class PersistentGetArrInfoByRouteListFetcher: GetArrInfoByRouteListFetchable {
    func fetch() {

    }
}

class ServiceGetArrInfoByRouteListFetcher: GetArrInfoByRouteListFetchable {
    func fetch() {

    }
}
