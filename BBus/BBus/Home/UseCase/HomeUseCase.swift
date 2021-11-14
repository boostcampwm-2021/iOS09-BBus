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

    private let homeModel: HomeModel
    private let usecases: GetFavoriteItemListUsecase & CreateFavoriteItemUsecase
    private var cancellable: Set<AnyCancellable>
    static let thread = DispatchQueue.init(label: "Home")
    @Published var favoriteList: [FavoriteItemDTO]?

    init(usecases: GetFavoriteItemListUsecase & CreateFavoriteItemUsecase) {
        self.homeModel = HomeModel()
        self.usecases = usecases
        self.cancellable = []
//        self.saveMOCKDATA()
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
        }
    }

    private func saveMOCKDATA() {
        let favoriteItem = FavoriteItemDTO(stId: "20000new", busRouteId: "461", ord: "왜필요?", arsId: "25340")
        self.usecases.createFavoriteItem(param: favoriteItem)
//            .receive(on: Self.thread)
            .sink { error in
                if case .failure(let error) = error {
                    print(error)
                }
            } receiveValue: { data in
                dump(String(data: data, encoding: .utf8))
            }
            .store(in: &self.cancellable)

    }
}
