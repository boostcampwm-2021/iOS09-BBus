//
//  GetArrInfoByRouteListUsable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetArrInfoByRouteListUsable {
    func getArrInfoByRouteList(stId: String, busRouteId: String, ord: String) -> AnyPublisher<Data, Error>
}
