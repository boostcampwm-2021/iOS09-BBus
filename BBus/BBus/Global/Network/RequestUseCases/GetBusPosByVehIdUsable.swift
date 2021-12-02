//
//  GetBusPosByVehIdUsable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetBusPosByVehIdUsable {
    func getBusPosByVehId(_ vehId: String) -> AnyPublisher<Data, Error>
}
