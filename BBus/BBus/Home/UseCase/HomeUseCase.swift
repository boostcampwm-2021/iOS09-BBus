//
//  HomeUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

typealias HomeUseCases = GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & GetStationListUsecase & GetRouteListUsecase & GetArrInfoByRouteListUsecase

class HomeUseCase {

    private let usecases: HomeUseCases
    private var cancellables: Set<AnyCancellable>
    static let queue = DispatchQueue.init(label: "Home")
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
        Self.queue.async { [weak self] in
            guard let self = self else { return }

            self.usecases.getFavoriteItemList()
                .receive(on: Self.queue)
                .decode(type: [FavoriteItemDTO]?.self, decoder: PropertyListDecoder())
                .retry({
                    self.loadFavoriteData()
                }, handler: { error in
                    self.networkError = error
                })
                .assign(to: \.favoriteList, on: self)
                .store(in: &self.cancellables)
        }
    }

    func loadBusRemainTime(favoriteItem: FavoriteItemDTO, completion: @escaping (ArrInfoByRouteDTO) -> Void) {
        Self.queue.async { [weak self] in
            guard let self = self else { return }

            self.usecases.getArrInfoByRouteList(stId: favoriteItem.stId,
                                                busRouteId: favoriteItem.busRouteId,
                                                ord: favoriteItem.ord)
                .receive(on: Self.queue)
                .tryMap({ data -> ArrInfoByRouteDTO in
                    guard let dto = BBusXMLParser().parse(dtoType: ArrInfoByRouteResult.self, xml: data),
                          let item = dto.body.itemList.first else { throw BBusAPIError.wrongFormatError }
                    return item
                })
                .retry({
                    self.loadBusRemainTime(favoriteItem: favoriteItem, completion: completion)
                }, handler: { error in
                    self.networkError = error
                })
                .sink(receiveValue: { item in
                    completion(item)
                })
                .store(in: &self.cancellables)
        }
    }

    private func loadStation() {
        Self.queue.async { [weak self] in
            guard let self = self else { return }

            self.usecases.getStationList()
                .receive(on: Self.queue)
                .decode(type: [StationDTO]?.self, decoder: JSONDecoder())
                .retry({
                    self.loadStation()
                }, handler: { error in
                    self.networkError = error
                })
                .assign(to: \.stationList, on: self)
                .store(in: &self.cancellables)
        }
    }

    private func loadRoute() {
        Self.queue.async { [weak self] in
            guard let self = self else { return }

            self.usecases.getRouteList()
                .receive(on: Self.queue)
                .decode(type: [BusRouteDTO]?.self, decoder: JSONDecoder())
                .retry({
                    self.loadRoute()
                }, handler: { error in
                    self.networkError = error
                })
                .assign(to: \.busRouteList, on: self)
                .store(in: &self.cancellables)
        }
    }
}
