//
//  HomeUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

protocol HomeAPIUsable: BaseUseCase {
    typealias HomeUseCases = GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & GetStationListUsecase & GetRouteListUsecase & GetArrInfoByRouteListUsecase

    func fetchFavoriteData() -> AnyPublisher<[FavoriteItemDTO], Never>
    func fetchBusRemainTime(favoriteItem: FavoriteItemDTO) -> AnyPublisher<ArrInfoByRouteDTO, Never>
    func fetchStation() -> AnyPublisher<[StationDTO], Never>
    func fetchBusRoute() -> AnyPublisher<[BusRouteDTO], Never>
}

final class HomeAPIUseCase: HomeAPIUsable {

    private let usecases: HomeUseCases
    @Published private(set) var networkError: Error?

    init(usecases: HomeUseCases) {
        self.usecases = usecases
        self.networkError = nil
    }

    func fetchFavoriteData() -> AnyPublisher<[FavoriteItemDTO], Never> {
        return self.usecases.getFavoriteItemList()
            .decode(type: [FavoriteItemDTO]?.self, decoder: PropertyListDecoder())
            .tryMap({ item in
                guard let item = item else { throw BBusAPIError.wrongFormatError }
                return item
            })
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .eraseToAnyPublisher()
    }

    func fetchBusRemainTime(favoriteItem: FavoriteItemDTO) -> AnyPublisher<ArrInfoByRouteDTO, Never> {
        return self.usecases.getArrInfoByRouteList(stId: favoriteItem.stId,
                                                   busRouteId: favoriteItem.busRouteId,
                                                   ord: favoriteItem.ord)
            .decode(type: ArrInfoByRouteResult.self, decoder: JSONDecoder())
            .tryMap({ item in
                let result = item.msgBody.itemList
                guard let item = result.first else { throw BBusAPIError.wrongFormatError }
                return item
            })
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .eraseToAnyPublisher()
    }

    func fetchStation() -> AnyPublisher<[StationDTO], Never> {
        self.usecases.getStationList()
            .decode(type: [StationDTO]?.self, decoder: JSONDecoder())
            .tryMap({ item in
                guard let item = item else { throw BBusAPIError.wrongFormatError }
                return item
            })
            .catchError { [weak self] error in
                self?.networkError = error
            }
            .eraseToAnyPublisher()
    }

    func fetchBusRoute() -> AnyPublisher<[BusRouteDTO], Never> {
        return self.usecases.getRouteList()
            .decode(type: [BusRouteDTO]?.self, decoder: JSONDecoder())
            .tryMap({ item in
                guard let item = item else { throw BBusAPIError.wrongFormatError }
                return item
            })
            .catchError { [weak self] error in
                self?.networkError = error
            }
            .eraseToAnyPublisher()
    }
}
