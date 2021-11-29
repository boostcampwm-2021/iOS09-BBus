//
//  HomeViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class HomeViewModel {

    let useCase: HomeAPIUseCase
    private var cancellables: Set<AnyCancellable>
    @Published private(set) var homeFavoriteList: HomeFavoriteList?
    private(set) var stationList: [StationDTO]?
    private(set) var busRouteList: [BusRouteDTO]?

    init(useCase: HomeAPIUseCase) {
        self.useCase = useCase
        self.cancellables = []
        self.loadBusRouteList()
        self.loadStationList()

        self.reloadFavorite()
    }

    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(descendTime), name: .oneSecondPassed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorite), name: .thirtySecondPassed, object: nil)
    }

    func cancelObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func descendTime() {
        self.homeFavoriteList?.descendAllTime()
    }

    @objc func reloadFavorite() {
        self.useCase.fetchFavoriteData()
            .sink { [weak self] favoriteItems in
                self?.homeFavoriteList = HomeFavoriteList(dtoList: favoriteItems)
                favoriteItems.forEach { [weak self] favoriteItem in
                    guard let self = self else { return }
                    self.useCase.fetchBusRemainTime(favoriteItem: favoriteItem)
                    .map({ arrInfoByRouteDTO in
                        return HomeArriveInfo(arrInfoByRouteDTO: arrInfoByRouteDTO)
                    })
                    .sink(receiveValue: { [weak self] homeArrivalInfo in
                        guard let indexPath = self?.homeFavoriteList?.indexPath(of: favoriteItem) else { return }
                        self?.homeFavoriteList?.configure(homeArrivalinfo: homeArrivalInfo, indexPath: indexPath)
                    })
                    .store(in: &self.cancellables)
                }
            }
            .store(in: &self.cancellables)
    }

    private func loadBusRouteList() {
        self.useCase.fetchBusRoute()
            .sink { [weak self] busRouteDTOs in
                self?.busRouteList = busRouteDTOs
            }
            .store(in: &self.cancellables)
    }

    private func loadStationList() {
        self.useCase.fetchStation()
            .sink { [weak self] stationDTOs in
                self?.stationList = stationDTOs
            }
            .store(in: &self.cancellables)
    }

    func stationName(by stationId: String) -> String? {
        guard let stationId = Int(stationId),
              let stationName = self.stationList?.first(where: { $0.stationID == stationId })?.stationName else { return nil }

        return stationName
    }

    func busName(by busRouteId: String) -> String? {
        guard let busRouteId = Int(busRouteId),
              let busName = self.busRouteList?.first(where: { $0.routeID == busRouteId })?.busRouteName else { return nil }

        return busName
    }

    func busType(by busName: String) -> RouteType? {
        return self.busRouteList?.first(where: { $0.busRouteName == busName } )?.routeType
    }
}
