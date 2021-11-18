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
    var stationList: [StationDTO]?
    var busRouteList: [BusRouteDTO]?
    @Published var favoriteList: [FavoriteItemDTO]?

    init(usecases: HomeUseCases) {
        self.usecases = usecases
        self.cancellables = []
        self.startHome()
    }

    private func startHome() {
        self.loadFavoriteData()
        self.loadStation()
        self.loadRoute()
    }

    func loadFavoriteData() {
        Self.queue.async {
            self.usecases.getFavoriteItemList()
                .receive(on: Self.queue)
                .decode(type: [FavoriteItemDTO].self, decoder: PropertyListDecoder())
                .sink(receiveCompletion: { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                }, receiveValue: { favoriteDTO in
                    self.favoriteList = favoriteDTO
                })
                .store(in: &self.cancellables)
        }
    }

    func loadBusRemainTime(favoriteItem: FavoriteItemDTO, completion: @escaping (ArrInfoByRouteDTO) -> Void) {
        Self.queue.async {
            self.usecases.getArrInfoByRouteList(stId: favoriteItem.stId,
                                                busRouteId: favoriteItem.busRouteId,
                                                ord: favoriteItem.ord)
                .receive(on: Self.queue)
                .sink { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                } receiveValue: { data in
                    guard let dto = BBusXMLParser().parse(dtoType: ArrInfoByRouteResult.self, xml: data),
                          let item = dto.body.itemList.first else { return }
                    completion(item)
                }
                .store(in: &self.cancellables)
        }
    }

    private func loadStation() {
        Self.queue.async {
            self.usecases.getStationList()
                .receive(on: Self.queue)
                .decode(type: [StationDTO].self, decoder: JSONDecoder())
                .sink(receiveCompletion: { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                }, receiveValue: { stationList in
                    self.stationList = stationList
                })
                .store(in: &self.cancellables)
        }
    }

    private func loadRoute() {
        Self.queue.async {
            self.usecases.getRouteList()
                .receive(on: Self.queue)
                .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
                .sink(receiveCompletion: { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                }, receiveValue: { busRouteList in
                    self.busRouteList = busRouteList
                })
                .store(in: &self.cancellables)
        }
    }
}
