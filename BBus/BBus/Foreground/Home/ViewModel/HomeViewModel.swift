//
//  HomeViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class HomeViewModel {

    let apiUseCase: HomeAPIUsable
    let calculateUseCase: HomeCalculateUsable
    private var cancellables: Set<AnyCancellable>
    @Published private(set) var homeFavoriteList: HomeFavoriteList?
    private(set) var stationList: [StationDTO]?
    private(set) var busRouteList: [BusRouteDTO]?

    @Published private(set) var networkError: Error?

    init(apiUseCase: HomeAPIUsable, calculateUseCase: HomeCalculateUsable) {
        self.apiUseCase = apiUseCase
        self.calculateUseCase = calculateUseCase
        self.cancellables = []
        self.loadBusRouteList()
        self.loadStationList()
        self.networkError = nil

        self.loadHomeData()
    }

    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(descendTime), name: .oneSecondPassed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadHomeData), name: .thirtySecondPassed, object: nil)
    }

    func cancelObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func descendTime() {
        self.homeFavoriteList?.descendAllTime()
    }

    @objc func loadHomeData() {
        self.apiUseCase.fetchFavoriteData()
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .sink { [weak self] favoriteItems in
                self?.homeFavoriteList = HomeFavoriteList(dtoList: favoriteItems)
                self?.loadRemainTime(with: favoriteItems)
            }
            .store(in: &self.cancellables)
    }

    private func loadRemainTime(with favoriteItems: [FavoriteItemDTO]) {
        guard let homeFavoriteList = homeFavoriteList else { return }

        var newHomeFavoriteList = homeFavoriteList
        favoriteItems.publisher
            .receive(on: DispatchQueue.global())
            .flatMap({ [weak self]  (favoriteItem) -> AnyPublisher<HomeFavoriteInfo, Error> in
                guard let self = self else { return NetworkError.unknownError.publisher }
                return self.apiUseCase.fetchBusRemainTime(favoriteItem: favoriteItem)
            })
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .map({ (homeFavoriteInfo) -> HomeFavoriteList? in
                guard let indexPath = newHomeFavoriteList.indexPath(of: homeFavoriteInfo.favoriteItem),
                      let arriveInfo = homeFavoriteInfo.arriveInfo else { return nil }
                newHomeFavoriteList.configure(homeArrivalinfo: arriveInfo, indexPath: indexPath)
                return newHomeFavoriteList
            })
            .compactMap({ $0 })
            .last()
            .assign(to: &self.$homeFavoriteList)
    }

    private func loadBusRouteList() {
        self.apiUseCase.fetchBusRoute()
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .sink { [weak self] busRouteDTOs in
                self?.busRouteList = busRouteDTOs
            }
            .store(in: &self.cancellables)
    }

    private func loadStationList() {
        self.apiUseCase.fetchStation()
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .sink { [weak self] stationDTOs in
                self?.stationList = stationDTOs
            }
            .store(in: &self.cancellables)
    }

    func stationName(by stationId: String) -> String? {
        return self.calculateUseCase.findStationName(in: self.stationList, by: stationId)
    }

    func busName(by busRouteId: String) -> String? {
        return self.calculateUseCase.findBusName(in: self.busRouteList, by: busRouteId)
    }

    func busType(by busName: String) -> RouteType? {
        return self.calculateUseCase.findBusType(in: self.busRouteList, by: busName)
    }
}

fileprivate extension Error {
    var publisher: AnyPublisher<HomeFavoriteInfo, Error> {
        let publisher = CurrentValueSubject<HomeFavoriteInfo?, Error>(nil)
        publisher.send(completion: .failure(self))
        return publisher.compactMap({$0})
            .eraseToAnyPublisher()
    }
}
