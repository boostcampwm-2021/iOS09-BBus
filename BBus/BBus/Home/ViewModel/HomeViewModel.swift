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
            .receive(on: HomeUseCase.thread)
            .sink(receiveValue: { favoriteItems in
                guard let favoriteItems = favoriteItems else { return }
                self.homeFavoriteList = HomeFavoriteList(dtoList: favoriteItems)
            })
    }

    func stationName(by stationId: String) -> String? {
        guard let stationId = Int(stationId),
              let stationName = self.useCase.stationList?.first(where: { $0.stationID == stationId })?.stationName else { return nil }

        return stationName
    }

    func busName(by busRouteId: String) -> String? {
        guard let busRouteId = Int(busRouteId),
              let busName = self.useCase.busRouteList?.first(where: { $0.routeID == busRouteId })?.busRouteName else { return nil }

        return busName
    }
}
