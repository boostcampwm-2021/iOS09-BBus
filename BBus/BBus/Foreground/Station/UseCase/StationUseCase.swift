//
//  StationUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class StationUsecase {
    typealias StationUsecases = GetStationByUidItemUsable & GetStationListUsable & CreateFavoriteItemUsable & DeleteFavoriteItemUsable & GetFavoriteItemListUsable & GetRouteListUsable
    
    private let usecases: StationUsecases
    @Published private(set) var busRouteList: [BusRouteDTO]
    @Published private(set) var busArriveInfo: [StationByUidItemDTO]
    @Published private(set) var stationInfo: StationDTO?
    @Published private(set) var favoriteItems: [FavoriteItemDTO] // need more
    @Published private(set) var networkError: Error?
    private var cancellables: Set<AnyCancellable>
    
    init(usecases: StationUsecases) {
        self.usecases = usecases
        self.busRouteList = []
        self.busArriveInfo = []
        self.stationInfo = nil
        self.cancellables = []
        self.favoriteItems = []
        self.networkError = nil
    }
    
    func stationInfoWillLoad(with arsId: String) {
        self.usecases.getStationList()
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .tryMap({ [weak self] stations in
                return self?.findStation(in: stations, with: arsId)
            })
            .retry({ [weak self] in
                self?.stationInfoWillLoad(with: arsId)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$stationInfo)
    }
    
    private func findStation(in stations: [StationDTO], with arsId: String) -> StationDTO? {
        let station = stations.filter() { $0.arsID == arsId }
        return station.first
    }
    
    func refreshInfo(about arsId: String) {
        self.usecases.getStationByUidItem(arsId: arsId)
            .decode(type: StationByUidItemResult.self, decoder: JSONDecoder())
            .tryMap({ item in
                item.msgBody.itemList
            })
            .retry({ [weak self] in
                self?.refreshInfo(about: arsId)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .combineLatest(self.$busRouteList) { (busRouteList, entireBusRouteList) in
                busRouteList.filter { busRoute in
                    entireBusRouteList.contains{ $0.routeID == busRoute.busRouteId }
                }
            }
            .assign(to: &self.$busArriveInfo)
    }
    
    func add(favoriteItem: FavoriteItemDTO) {
        self.usecases.createFavoriteItem(param: favoriteItem)
            .retry({ [weak self] in
                self?.add(favoriteItem: favoriteItem)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .sink(receiveValue: { [weak self] _ in
                self?.getFavoriteItems()
            })
            .store(in: &self.cancellables)
    }
    
    func remove(favoriteItem: FavoriteItemDTO) {
        self.usecases.deleteFavoriteItem(param: favoriteItem)
            .retry({ [weak self] in
                self?.remove(favoriteItem: favoriteItem)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .sink(receiveValue: { [weak self] _ in
                self?.getFavoriteItems()
            })
            .store(in: &self.cancellables)
    }
    
    func getFavoriteItems() {
        self.usecases.getFavoriteItemList()
            .decode(type: [FavoriteItemDTO].self, decoder: PropertyListDecoder())
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$favoriteItems)
    }
    
    func loadRoute() {
        self.usecases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .retry({ [weak self] in
                self?.loadRoute()
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$busRouteList)
    }
}
