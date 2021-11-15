//
//  StationUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class StationUsecase {
    static let queue = DispatchQueue.init(label: "station")
    
    typealias StationUsecases = GetStationByUidItemUsecase & GetStationListUsecase & CreateFavoriteItemUsecase & DeleteFavoriteItemUsecase & GetFavoriteItemListUsecase
    
    private let usecases: StationUsecases
    @Published private(set) var busArriveInfo: [StationByUidItemDTO]
    @Published private(set) var stationInfo: StationDTO?
    @Published private(set) var favoriteItems: [FavoriteItemDTO] // need more
    private var cancellables: Set<AnyCancellable>
    
    init(usecases: StationUsecases) {
        self.usecases = usecases
        self.busArriveInfo = []
        self.stationInfo = nil
        self.cancellables = []
        self.favoriteItems = []
        self.getFavoriteItems()
    }
    
    func stationInfoWillLoad(with arsId: String) {
        self.usecases.getStationList()
            .receive(on: Self.queue)
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { stations in
                self.stationInfo = self.findStation(in: stations, with: arsId)
            })
            .store(in: &self.cancellables)
    }
    
    private func findStation(in stations: [StationDTO], with arsId: String) -> StationDTO? {
        let station = stations.filter() { $0.arsID == arsId }
        return station.first
    }
    
    func refreshInfo(about arsId: String) {
        self.usecases.getStationByUidItem(arsId: arsId)
            .receive(on: Self.queue)
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { data in
                guard let result = BBusXMLParser().parse(dtoType: StationByUidItemResult.self, xml: data) else { return }
                let realTimeInfo = result.body.itemList
                self.busArriveInfo = realTimeInfo
            })
            .store(in: &self.cancellables)
    }
    
    func add(favoriteItem: FavoriteItemDTO) {
        self.usecases.createFavoriteItem(param: favoriteItem)
            .receive(on: Self.queue)
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { _ in
                self.getFavoriteItems()
                return
            })
            .store(in: &self.cancellables)
    }
    
    func remove(favoriteItem: FavoriteItemDTO) {
        self.usecases.deleteFavoriteItem(param: favoriteItem)
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { _ in
                self.getFavoriteItems()
                return
            })
            .store(in: &self.cancellables)
    }
    
    private func getFavoriteItems() {
        self.usecases.getFavoriteItemList()
            .decode(type: [FavoriteItemDTO].self, decoder: PropertyListDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { items in
                self.favoriteItems = items
            })
            .store(in: &self.cancellables)
    }
}
