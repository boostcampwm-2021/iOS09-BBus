//
//  StationAPIUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
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

final class StationAPIUseCase: StationAPIUsable {
    typealias StationUseCases = GetStationByUidItemUsable & GetStationListUsable & CreateFavoriteItemUsable & DeleteFavoriteItemUsable & GetFavoriteItemListUsable & GetRouteListUsable
    
    private let useCases: StationUseCases
    private var cancellables: Set<AnyCancellable>
    
    init(useCases: StationUseCases) {
        self.useCases = useCases
        self.cancellables = []
    }
    
    func loadStationList() -> AnyPublisher<[StationDTO], Error> {
        self.useCases.getStationList()
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func refreshInfo(about arsId: String) -> AnyPublisher<[StationByUidItemDTO], Error> {
        return self.useCases.getStationByUidItem(arsId: arsId)
            .decode(type: StationByUidItemResult.self, decoder: JSONDecoder())
            .tryMap({ item in
                item.msgBody.itemList
            })
            .eraseToAnyPublisher()
    }
    
    func add(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        return self.useCases.createFavoriteItem(param: favoriteItem)
            .eraseToAnyPublisher()
    }
    
    func remove(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        return self.useCases.deleteFavoriteItem(param: favoriteItem)
            .eraseToAnyPublisher()
    }
    
    func getFavoriteItems() -> AnyPublisher<[FavoriteItemDTO], Error> {
        return self.useCases.getFavoriteItemList()
            .decode(type: [FavoriteItemDTO].self, decoder: PropertyListDecoder())
            .eraseToAnyPublisher()
    }
    
    func loadRoute() -> AnyPublisher<[BusRouteDTO], Error> {
        return self.useCases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
