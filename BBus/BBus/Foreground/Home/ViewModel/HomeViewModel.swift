//
//  HomeViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class HomeViewModel {

    let useCase: HomeUseCase
    private var cancellables: Set<AnyCancellable>
    @Published private(set) var homeFavoriteList: HomeFavoriteList?

    init(useCase: HomeUseCase) {
        self.useCase = useCase
        self.cancellables = []
        self.bindFavoriteData()
    }

    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(descendTime), name: .oneSecondPassed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavoriteData), name: .thirtySecondPassed, object: nil)
    }

    func cancelObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func descendTime() {
        self.homeFavoriteList?.descendAllTime()
    }

    private func bindFavoriteData() {
        self.useCase.$favoriteList
            .sink(receiveValue: { [weak self] favoriteItems in
                guard let self = self,
                      let favoriteItems = favoriteItems else { return }
                self.homeFavoriteList = HomeFavoriteList(dtoList: favoriteItems)
                favoriteItems.forEach({ [weak self] favoriteItem in
                    guard let self = self else { return }
                    self.useCase.loadBusRemainTime(favoriteItem: favoriteItem)
                        .map({ arrInfoByRouteDTO in
                            return HomeArriveInfo(arrInfoByRouteDTO: arrInfoByRouteDTO)
                        })
                        .sink(receiveValue: { [weak self] homeArrivalInfo in
                            guard let indexPath = self?.homeFavoriteList?.indexPath(of: favoriteItem) else { return }
                            self?.homeFavoriteList?.configure(homeArrivalinfo: homeArrivalInfo, indexPath: indexPath)
                        })
                        .store(in: &self.cancellables)
                })
            })
            .store(in: &self.cancellables)
    }

    @objc func reloadFavoriteData() {
        self.useCase.loadFavoriteData()
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

    func busType(by busName: String) -> RouteType? {
        return self.useCase.busRouteList?.first(where: { $0.busRouteName == busName } )?.routeType
    }
}
