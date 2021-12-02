//
//  SearchAPIUsable.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
//

import Foundation
import Combine

protocol SearchAPIUsable: BaseUseCase {
    func loadBusRouteList() -> AnyPublisher<[BusRouteDTO], Error>
    func loadStationList() -> AnyPublisher<[StationDTO], Error>
}
