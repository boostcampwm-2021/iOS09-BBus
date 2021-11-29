//
//  StationAPIUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

protocol StationAPIUsable: BaseUseCase {
    func loadStationInfo(with arsId: String) -> AnyPublisher<StationDTO?, Error>
    func refreshInfo(about arsId: String) -> AnyPublisher<[StationByUidItemDTO], Error>
    func add(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error>
    func remove(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error>
    func getFavoriteItems() -> AnyPublisher<[FavoriteItemDTO], Error>
    func loadRoute() -> AnyPublisher<[BusRouteDTO], Error>
}

final class StationAPIUseCase: StationAPIUsable {
    typealias StationUsecases = GetStationByUidItemUsecase & GetStationListUsecase & CreateFavoriteItemUsecase & DeleteFavoriteItemUsecase & GetFavoriteItemListUsecase & GetRouteListUsecase
    
    private let usecases: StationUsecases
    private var cancellables: Set<AnyCancellable>
    
    init(usecases: StationUsecases) {
        self.usecases = usecases
        self.cancellables = []
    }
    
    func loadStationInfo(with arsId: String) -> AnyPublisher<StationDTO?, Error> {
        self.usecases.getStationList()
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .tryMap({ [weak self] stations in
                return self?.findStation(in: stations, with: arsId)
            })
            .eraseToAnyPublisher()
    }
    
    private func findStation(in stations: [StationDTO], with arsId: String) -> StationDTO? {
        let station = stations.filter() { $0.arsID == arsId }
        return station.first
    }
    
    func refreshInfo(about arsId: String) -> AnyPublisher<[StationByUidItemDTO], Error> {
        return self.usecases.getStationByUidItem(arsId: arsId)
            .decode(type: StationByUidItemResult.self, decoder: JSONDecoder())
            .tryMap({ item in
                item.msgBody.itemList
            })
            .eraseToAnyPublisher()
    }
    
    func add(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        return self.usecases.createFavoriteItem(param: favoriteItem)
            .eraseToAnyPublisher()
    }
    
    func remove(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
        return self.usecases.deleteFavoriteItem(param: favoriteItem)
            .eraseToAnyPublisher()
    }
    
    func getFavoriteItems() -> AnyPublisher<[FavoriteItemDTO], Error> {
        return self.usecases.getFavoriteItemList()
            .decode(type: [FavoriteItemDTO].self, decoder: PropertyListDecoder())
            .eraseToAnyPublisher()
    }
    
    func loadRoute() -> AnyPublisher<[BusRouteDTO], Error> {
        return self.usecases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
