//
//  GetStationsByRouteListUsable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetStationsByRouteListUsable {
    func getStationsByRouteList(busRoutedId: String) -> AnyPublisher<Data, Error>
}
