//
//  HomeUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class HomeUseCase {

    private let usecases: GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & GetStationListUsecase & GetRouteListUsecase & GetArrInfoByRouteListUsecase
    private var cancellables: Set<AnyCancellable>
    static let thread = DispatchQueue.init(label: "Home")
    var stationList: [StationDTO]?
    var busRouteList: [BusRouteDTO]?
    @Published var favoriteList: [FavoriteItemDTO]?
    @Published private(set) var networkError: Error?

    init(usecases: GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & GetStationListUsecase & GetRouteListUsecase & GetArrInfoByRouteListUsecase) {
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
        Self.thread.async {
            self.usecases.getFavoriteItemList()
                .receive(on: Self.thread)
                .decode(type: [FavoriteItemDTO]?.self, decoder: PropertyListDecoder())
                .retry({ [weak self] in
                    self?.loadFavoriteData()
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .assign(to: \.favoriteList, on: self)
                .store(in: &self.cancellables)
        }
    }

    func loadBusRemainTime(favoriteItem: FavoriteItemDTO, completion: @escaping (ArrInfoByRouteDTO) -> Void) {
        Self.thread.async {
            self.usecases.getArrInfoByRouteList(stId: favoriteItem.stId,
                                                busRouteId: favoriteItem.busRouteId,
                                                ord: favoriteItem.ord)
                .receive(on: Self.thread)
                .tryMap({ data -> ArrInfoByRouteDTO in
                    guard let dto = BBusXMLParser().parse(dtoType: ArrInfoByRouteResult.self, xml: data),
                          let item = dto.body.itemList.first else { throw BBusAPIError.wrongFormatError }
                    return item
                })
                .retry({ [weak self] in
                    self?.loadBusRemainTime(favoriteItem: favoriteItem, completion: completion)
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .sink(receiveValue: { item in
                    completion(item)
                })
                .store(in: &self.cancellables)
        }
    }

    private func loadStation() {
        Self.thread.async {
            self.usecases.getStationList()
                .receive(on: Self.thread)
                .decode(type: [StationDTO]?.self, decoder: JSONDecoder())
                .retry({ [weak self] in
                    self?.loadStation()
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .assign(to: \.stationList, on: self)
                .store(in: &self.cancellables)
        }
    }

    private func loadRoute() {
        Self.thread.async {
            self.usecases.getRouteList()
                .receive(on: Self.thread)
                .decode(type: [BusRouteDTO]?.self, decoder: JSONDecoder())
                .retry({ [weak self] in
                    self?.loadRoute()
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .assign(to: \.busRouteList, on: self)
                .store(in: &self.cancellables)
        }
    }
}
