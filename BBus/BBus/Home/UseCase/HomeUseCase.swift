//
//  HomeUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine
import os

class HomeUseCase {

    private let usecases: GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & CreateFavoriteOrderUsecase & GetFavoriteOrderListUsecase & GetStationListUsecase & GetRouteListUsecase
    private var cancellables: Set<AnyCancellable>
    static let thread = DispatchQueue.init(label: "Home")
    var stationList: [StationDTO]?
    var busRouteList: [BusRouteDTO]?
    @Published var favoriteList: [FavoriteItemDTO]?
    @Published var favoriteOrderList: [FavoriteOrderDTO]?

    init(usecases: GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & CreateFavoriteOrderUsecase & GetFavoriteOrderListUsecase & GetStationListUsecase & GetRouteListUsecase) {
        self.usecases = usecases
        self.cancellables = []
        self.saveMOCKDATA()
        self.startHome()
    }

    private func startHome() {
        self.loadFavoriteData()
        self.loadStation()
        self.loadRoute()
    }

    private func saveMOCKDATA() {
        let favoriteItem = FavoriteItemDTO(stId: "122000248", busRouteId: "100100063", ord: "87", arsId: "23352")
        self.usecases.createFavoriteItem(param: favoriteItem)
            .receive(on: Self.thread)
            .sink { error in
                if case .failure(let error) = error {
                    print(error)
                }
            } receiveValue: { data in
//                dump(String(data: data, encoding: .utf8))
            }
            .store(in: &self.cancellables)

        let favoriteOrder = FavoriteOrderDTO(stationId: "122000248", order: 1)
        self.usecases.createFavoriteOrder(param: favoriteOrder)
            .receive(on: Self.thread)
            .sink { error in
                if case .failure(let error) = error {
                    print(error)
                }
            } receiveValue: { data in
//                dump(String(data: data, encoding: .utf8))
            }
            .store(in: &self.cancellables)
    }

    private func loadFavoriteData() {
        Self.thread.async {
            self.usecases.getFavoriteItemList()
    //            .receive(on: Self.thread)
                .decode(type: [FavoriteItemDTO].self, decoder: PropertyListDecoder())
                .sink(receiveCompletion: { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                }, receiveValue: { favoriteDTO in
//                    dump(favoriteDTO)
    //                print("fewj")
                    self.favoriteList = favoriteDTO
                })
                .store(in: &self.cancellables)

            self.usecases.getFavoriteOrderList()
                .decode(type: [FavoriteOrderDTO].self, decoder: PropertyListDecoder())
                .sink(receiveCompletion: { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                }, receiveValue: { favoriteOrderListDTO in
//                    dump(favoriteOrderListDTO)
                    self.favoriteOrderList = favoriteOrderListDTO
                })
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
