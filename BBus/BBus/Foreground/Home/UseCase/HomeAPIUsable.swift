//
//  HomeAPIUsable.swift
//  BBus
//
//  Created by 최수정 on 2021/12/01.
//

import Foundation
import Combine

protocol HomeAPIUsable: BaseUseCase {
    typealias HomeUseCases = GetFavoriteItemListUsable & CreateFavoriteItemUsable & GetStationListUsable & GetRouteListUsable & GetArrInfoByRouteListUsable

    func fetchFavoriteData() -> AnyPublisher<[FavoriteItemDTO], Error>
    func fetchBusRemainTime(favoriteItem: FavoriteItemDTO) -> AnyPublisher<HomeFavoriteInfo, Error>
    func fetchStation() -> AnyPublisher<[StationDTO], Error>
    func fetchBusRoute() -> AnyPublisher<[BusRouteDTO], Error>
}
