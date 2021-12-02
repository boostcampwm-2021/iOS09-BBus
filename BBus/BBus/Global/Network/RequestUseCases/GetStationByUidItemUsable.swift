//
//  GetStationByUidItemUsable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol GetStationByUidItemUsable {
    func getStationByUidItem(arsId: String) -> AnyPublisher<Data, Error>
}
