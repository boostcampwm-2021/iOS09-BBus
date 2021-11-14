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
    @Published private(set) var homeFavoriteList: HomeFavoriteList?

    init(useCase: HomeUseCase) {
        self.useCase = useCase
        self.loadFavoriteData()
    }

    private func loadFavoriteData() {
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

    func stationName(by stationId: String) -> String? {
        guard let stationId = Int(stationId),
              let stationName = self.useCase.stationList?.first(where: { $0.stationID == stationId })?.stationName else { return nil }

        return stationName
    }

}
