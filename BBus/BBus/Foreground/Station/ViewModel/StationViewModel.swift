//
//  StationViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine
import UIKit

final class StationViewModel {
    
    let apiUseCase: StationAPIUsable
    let calculateUseCase: StationCalculatable
    let arsId: String
    @Published private(set) var stationInfo: StationDTO?
    @Published private(set) var busRouteList: [BusRouteDTO]
    @Published private(set) var busKeys: BusSectionKeys
    @Published private(set) var activeBuses: [BBusRouteType: BusArriveInfos]
    private(set) var inActiveBuses: [BBusRouteType: BusArriveInfos]
    @Published private(set) var favoriteItems: [FavoriteItemDTO]?
    @Published private(set) var nextStation: String?
    @Published private(set) var stopLoader: Bool
    private var cancellables: Set<AnyCancellable>
    @Published private(set) var error: Error?
    
    init(apiUseCase: StationAPIUsable, calculateUseCase: StationCalculatable, arsId: String) {
        self.apiUseCase = apiUseCase
        self.calculateUseCase = calculateUseCase
        self.arsId = arsId
        self.busRouteList = []
        self.busKeys = BusSectionKeys()
        self.activeBuses = [:]
        self.inActiveBuses = [:]
        self.cancellables = []
        self.stopLoader = false
        
        self.load()
        self.bind()
    }

    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(descendTime), name: .oneSecondPassed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .thirtySecondPassed, object: nil)
    }

    func cancelObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refresh() {
        self.apiUseCase.refreshInfo(about: self.arsId)
            .receive(on: DispatchQueue.global())
            .catchError({ [weak self] error in
                self?.error = error
            })
            .combineLatest(self.$busRouteList.filter { !$0.isEmpty }) { (busRouteList, entireBusRouteList) in
                busRouteList.filter { busRoute in
                    entireBusRouteList.contains{ $0.routeID == busRoute.busRouteId }
                }
            }
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] arriveInfo in
                self?.nextStation = arriveInfo[0].nextStation
                self?.classifyByRouteType(with: arriveInfo)
            })
            .store(in: &self.cancellables)
    }

    @objc private func descendTime() {
        self.activeBuses.forEach({ [weak self] in
            self?.activeBuses[$0.key] = $0.value.descended()
        })
    }
    
    private func load() {
        self.loadStationInfo(with: self.arsId)
        self.loadRoute()
    }

    private func loadStationInfo(with arsId: String) {
        self.apiUseCase.loadStationList()
            .tryMap({ [weak self] stations in
                return self?.calculateUseCase.findStation(in: stations, with: arsId)
            })
            .catchError({ [weak self] error in
                self?.error = error
            })
            .sink { [weak self] stationInfo in
                if let stationInfo = stationInfo {
                    self?.stationInfo = stationInfo
                }
                else {
                    self?.error = BBusAPIError.invalidStationError
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func loadRoute() {
        self.apiUseCase.loadRoute()
            .catchError({ [weak self] error in
                self?.error = error
            })
            .assign(to: &self.$busRouteList)
    }
    
    private func bind() {
        self.bindLoader()
        self.bindFavoriteItems()
    }
    
    private func bindFavoriteItems() {
        self.apiUseCase.getFavoriteItems()
            .receive(on: DispatchQueue.global())
            .catchError({ [weak self] error in
                self?.error = error
            })
            .sink(receiveValue: { [weak self] items in
                self?.favoriteItems = items.filter() { $0.arsId == self?.arsId }
            })
            .store(in: &self.cancellables)
    }

    private func classifyByRouteType(with buses: [StationByUidItemDTO]) {
        var activeBuses: [BBusRouteType: BusArriveInfos] = [:]
        var inActiveBuses: [BBusRouteType: BusArriveInfos] = [:]
        buses.forEach() { bus in
            guard let routeType = BBusRouteType(rawValue: Int(bus.routeType) ?? 0) else { return }
            
            let info: BusArriveInfo
            info.routeType = routeType
            info.firstBusCongestion = BusCongestion(rawValue: bus.congestion)
            
            info.nextStation = bus.nextStation
            info.busNumber = bus.busNumber
            info.stationOrd = bus.stationOrd
            info.busRouteId = bus.busRouteId
            
            let timeAndPositionInfo1 = AlarmSettingBusArriveInfo.seperateTimeAndPositionInfo(with: bus.firstBusArriveRemainTime)
            if timeAndPositionInfo1.time.checkInfo() {
                info.firstBusArriveRemainTime = timeAndPositionInfo1.time
                info.firstBusRelativePosition = timeAndPositionInfo1.position
                
                let timeAndPositionInfo2 = AlarmSettingBusArriveInfo.seperateTimeAndPositionInfo(with: bus.secondBusArriveRemainTime)
                info.secondBusArriveRemainTime = timeAndPositionInfo2.time
                info.secondBusRelativePosition = timeAndPositionInfo2.position
                info.secondBusCongestion = timeAndPositionInfo2.time.checkInfo() ? info.firstBusCongestion : nil

                activeBuses.updateValue((activeBuses[routeType] ?? BusArriveInfos()) + BusArriveInfos(infos: [info]), forKey: routeType)
            }
            else {
                info.firstBusArriveRemainTime = nil
                info.firstBusRelativePosition = nil
                info.secondBusArriveRemainTime = nil
                info.secondBusRelativePosition = nil
                info.secondBusCongestion = nil
                
                inActiveBuses.updateValue((inActiveBuses[routeType] ?? BusArriveInfos()) + BusArriveInfos(infos: [info]), forKey: routeType)
            }
        }
        self.activeBuses = activeBuses
        self.inActiveBuses = inActiveBuses

        let sortedInfoBusesKey = Array(activeBuses.keys).sorted(by: { $0.rawValue < $1.rawValue })
        let sortedNoInfoBusesKey = Array(inActiveBuses.keys).sorted(by: { $0.rawValue < $1.rawValue })
        self.busKeys = BusSectionKeys(keys: sortedInfoBusesKey) + BusSectionKeys(keys: sortedNoInfoBusesKey)
    }
    
    func add(favoriteItem: FavoriteItemDTO) {
        self.apiUseCase.add(favoriteItem: favoriteItem)
            .catchError({ [weak self] error in
                self?.error = error
            })
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.apiUseCase.getFavoriteItems()
                    .catchError({ [weak self] error in
                        self?.error = error
                    })
                    .compactMap { $0 }
                    .assign(to: &self.$favoriteItems)
            }
            .store(in: &self.cancellables)
    }
    
    func remove(favoriteItem: FavoriteItemDTO) {
        self.apiUseCase.remove(favoriteItem: favoriteItem)
            .catchError({ [weak self] error in
                self?.error = error
            })
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.apiUseCase.getFavoriteItems()
                    .catchError({ [weak self] error in
                        self?.error = error
                    })
                    .compactMap { $0 }
                    .assign(to: &self.$favoriteItems)
            }
            .store(in: &self.cancellables)
    }

    private func bindLoader() {
        self.$busKeys.zip(self.$favoriteItems, self.$stationInfo)
            .first()
            .sink(receiveValue: { _ in
                self.stopLoader = true
            })
            .store(in: &self.cancellables)
        
        self.$busKeys
            .dropFirst(2)
            .sink(receiveValue: { result in
                self.stopLoader = true
            })
            .store(in: &self.cancellables)
    }
}
