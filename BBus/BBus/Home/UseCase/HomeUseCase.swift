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

    init(usecases: GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & GetStationListUsecase & GetRouteListUsecase & GetArrInfoByRouteListUsecase) {
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
        Self.thread.async {
            self.usecases.getFavoriteItemList()
                .receive(on: Self.thread)
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
        Self.thread.async {
            self.usecases.getArrInfoByRouteList(stId: favoriteItem.stId,
                                                busRouteId: favoriteItem.busRouteId,
                                                ord: favoriteItem.ord)
                .receive(on: Self.thread)
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
        Self.thread.async {
            self.usecases.getStationList()
                .receive(on: Self.thread)
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
        Self.thread.async {
            self.usecases.getRouteList()
                .receive(on: Self.thread)
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
