//
//  HomeUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

typealias HomeUseCases = GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & GetStationListUsecase & GetRouteListUsecase & GetArrInfoByRouteListUsecase

final class HomeUseCase {

    private let usecases: HomeUseCases
    private var cancellables: Set<AnyCancellable>
    private(set) var stationList: [StationDTO]?
    private(set) var busRouteList: [BusRouteDTO]?
    @Published var favoriteList: [FavoriteItemDTO]?
    @Published private(set) var networkError: Error?

    init(usecases: HomeUseCases) {
        self.usecases = usecases
        self.cancellables = []
        self.networkError = nil
        self.startHome()
    }

    private func startHome() {
        self.loadFavoriteData()
        self.loadStation()
        self.loadRoute()
    }

    func loadFavoriteData() {
        self.usecases.getFavoriteItemList()
            .decode(type: [FavoriteItemDTO]?.self, decoder: PropertyListDecoder())
            .retry({ [weak self] in
                self?.loadFavoriteData()
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$favoriteList)
    }

    func loadBusRemainTime(favoriteItem: FavoriteItemDTO) -> AnyPublisher<ArrInfoByRouteDTO, Never> {
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

    private func loadStation() {
        self.usecases.getStationList()
            .decode(type: [StationDTO]?.self, decoder: JSONDecoder())
            .retry({ [weak self] in
                self?.loadStation()
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .sink(receiveValue: { [weak self] stationList in
                self?.stationList = stationList
            })
            .store(in: &self.cancellables)
    }

    private func loadRoute() {
        self.usecases.getRouteList()
            .decode(type: [BusRouteDTO]?.self, decoder: JSONDecoder())
            .retry({ [weak self] in
                self?.loadRoute()
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .sink(receiveValue: { [weak self] busRouteList in
                self?.busRouteList = busRouteList
            })
            .store(in: &self.cancellables)
    }
}
