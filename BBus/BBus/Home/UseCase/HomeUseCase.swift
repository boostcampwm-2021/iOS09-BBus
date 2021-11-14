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

    private let usecases: GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & CreateFavoriteOrderUsecase & GetFavoriteOrderListUsecase
    private var cancellable: Set<AnyCancellable>
    static let thread = DispatchQueue.init(label: "Home")
    @Published var favoriteList: [FavoriteItemDTO]?
    @Published var favoriteOrderList: [FavoriteOrderDTO]?

    init(usecases: GetFavoriteItemListUsecase & CreateFavoriteItemUsecase & CreateFavoriteOrderUsecase & GetFavoriteOrderListUsecase) {
        self.usecases = usecases
        self.cancellable = []
        self.saveMOCKDATA()
        self.startHome()
    }

    private func startHome() {
        Self.thread.async {
            self.usecases.getFavoriteItemList()
    //            .receive(on: Self.thread)
                .decode(type: [FavoriteItemDTO].self, decoder: PropertyListDecoder())
                .sink(receiveCompletion: { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                }, receiveValue: { favoriteDTO in
                    dump(favoriteDTO)
    //                print("fewj")
                    self.favoriteList = favoriteDTO
                })
                .store(in: &self.cancellable)

            self.usecases.getFavoriteOrderList()
                .decode(type: [FavoriteOrderDTO].self, decoder: PropertyListDecoder())
                .sink(receiveCompletion: { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                }, receiveValue: { favoriteOrderListDTO in
                    dump(favoriteOrderListDTO)
                    self.favoriteOrderList = favoriteOrderListDTO
                })
                .store(in: &self.cancellable)
        }

    }

    private func saveMOCKDATA() {
        let favoriteItem = FavoriteItemDTO(stId: "20000new", busRouteId: "461_two", ord: "왜필요?", arsId: "25340")
        self.usecases.createFavoriteItem(param: favoriteItem)
            .receive(on: Self.thread)
            .sink { error in
                if case .failure(let error) = error {
                    print(error)
                }
            } receiveValue: { data in
//                dump(String(data: data, encoding: .utf8))
            }
            .store(in: &self.cancellable)

        let favoriteOrder = FavoriteOrderDTO(stationId: "20000new", order: 2)
        self.usecases.createFavoriteOrder(param: favoriteOrder)
            .receive(on: Self.thread)
            .sink { error in
                if case .failure(let error) = error {
                    print(error)
                }
            } receiveValue: { data in
//                dump(String(data: data, encoding: .utf8))
            }
            .store(in: &self.cancellable)
    }
}
