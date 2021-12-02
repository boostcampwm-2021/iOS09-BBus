//
//  StationAPIUsable.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
//

import Foundation
import Combine

protocol StationAPIUsable: BaseUseCase {
    func loadStationList() -> AnyPublisher<[StationDTO], Error>
    func refreshInfo(about arsId: String) -> AnyPublisher<[StationByUidItemDTO], Error>
    func add(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error>
    func remove(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error>
    func getFavoriteItems() -> AnyPublisher<[FavoriteItemDTO], Error>
    func loadRoute() -> AnyPublisher<[BusRouteDTO], Error>
}
