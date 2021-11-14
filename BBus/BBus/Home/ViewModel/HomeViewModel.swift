//
//  HomeViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class HomeViewModel {

    private let useCase: HomeUseCase
    private var cancellable: AnyCancellable?
//    private(set) var orderedFavoriteItemList: [FavoriteItemDTO]?
    @Published private(set) var homeFavoriteList: HomeFavoriteList?

    init(useCase: HomeUseCase) {
        self.useCase = useCase
        self.prepare()
    }

    private func prepare() {
        self.cancellable = self.useCase.$favoriteList
            .zip(self.useCase.$favoriteOrderList)
            .receive(on: HomeUseCase.thread)
            .sink(receiveValue: { (favoriteListDTO, favoriteOrderListDTO) in
                guard let favoriteListDTO = favoriteListDTO,
                      let favoriteOrderListDTO = favoriteOrderListDTO else { return }
                let favoriteList = HomeFavoriteList()
                favoriteListDTO.forEach({
                    favoriteList.append(newElement: $0)
                })
                favoriteList.sort(by: favoriteOrderListDTO)
                self.homeFavoriteList = favoriteList
            })
    }

}
