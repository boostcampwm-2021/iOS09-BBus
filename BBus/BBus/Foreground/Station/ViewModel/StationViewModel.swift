//
//  StationViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine
import UIKit

typealias BusArriveInfo = (firstBusArriveRemainTime: BusRemainTime?, firstBusRelativePosition: String?, firstBusCongestion: BusCongestion?, secondBusArriveRemainTime: BusRemainTime?, secondBusRelativePosition: String?, secondBusCongestion: BusCongestion?, arsId: String, stationOrd: Int, busRouteId: Int, nextStation: String, busNumber: String, routeType: BBusRouteType)


class StationViewModel {
    
    let usecase: StationUsecase
    let arsId: String
    private var cancellables: Set<AnyCancellable>
    @Published private(set) var busKeys: [BBusRouteType]
    @Published private(set) var infoBuses = [BBusRouteType: [BusArriveInfo]]()
    private(set) var noInfoBuses = [BBusRouteType: [BusArriveInfo]]()
    @Published private(set) var favoriteItems = [FavoriteItemDTO]()
    @Published private(set) var nextStation: String? = nil
    
    init(usecase: StationUsecase, arsId: String) {
        self.usecase = usecase
        self.arsId = arsId
        self.cancellables = []
        self.busKeys = []
        self.binding()
        self.refresh()
        self.configureObserver()
    }

    private func configureObserver() {
        NotificationCenter.default.addObserver(forName: .oneSecondPassed, object: nil, queue: .main) { [weak self] _ in
            self?.descendTime()
        }
        NotificationCenter.default.addObserver(forName: .thirtySecondPassed, object: nil, queue: .main) { [weak self] _ in
            self?.refresh()
        }
    }
    
    func refresh() {
        self.usecase.stationInfoWillLoad(with: arsId)
        self.usecase.refreshInfo(about: arsId)
    }

    private func descendTime() {
        self.infoBuses.forEach({ [weak self] in
            self?.infoBuses[$0.key] = $0.value.map { result in
                var remainTime = result
                remainTime.firstBusArriveRemainTime?.descend()
                remainTime.secondBusArriveRemainTime?.descend()
                return remainTime
            }
        })
    }
    
    private func binding() {
        self.bindingFavoriteItems()
        self.bindingBusArriveInfo()
    }
    
    private func bindingBusArriveInfo() {
        self.usecase.$busArriveInfo
            .receive(on: StationUsecase.queue)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] arriveInfo in
                guard arriveInfo.count > 0 else { return }
                self?.nextStation = arriveInfo[0].nextStation
                self?.classifyByRouteType(with: arriveInfo)
            })
            .store(in: &self.cancellables)
    }
    
    private func bindingFavoriteItems() {
        self.usecase.$favoriteItems
            .receive(on: StationUsecase.queue)
            .sink(receiveValue: { [weak self] items in
                self?.favoriteItems = items.filter() { $0.arsId == self?.arsId }
            })
            .store(in: &self.cancellables)
    }

    private func classifyByRouteType(with buses: [StationByUidItemDTO]) {
        var infoBuses: [BBusRouteType: [BusArriveInfo]] = [:]
        var noInfoBuses: [BBusRouteType: [BusArriveInfo]] = [:]
        buses.forEach() { bus in
            guard let routeType = BBusRouteType(rawValue: Int(bus.routeType) ?? 0) else { return }
            
            let info: BusArriveInfo
            info.routeType = routeType
            info.firstBusCongestion = BusCongestion(rawValue: bus.congestion)
            
            info.nextStation = bus.nextStation
            info.busNumber = bus.busNumber
            info.arsId = bus.arsId
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
                
                infoBuses.updateValue((infoBuses[routeType] ?? []) + [info], forKey: routeType)
            }
            else {
                info.firstBusArriveRemainTime = nil
                info.firstBusRelativePosition = nil
                info.secondBusArriveRemainTime = nil
                info.secondBusRelativePosition = nil
                info.secondBusCongestion = nil
                
                noInfoBuses.updateValue((noInfoBuses[routeType] ?? []) + [info], forKey: routeType)
            }
        }
        self.infoBuses = infoBuses
        self.noInfoBuses = noInfoBuses
        
        let keys = Array(infoBuses.keys).sorted(by: { $0.rawValue < $1.rawValue }) + Array(noInfoBuses.keys).sorted(by: { $0.rawValue < $1.rawValue })
        self.busKeys = keys
    }
    
    func add(favoriteItem: FavoriteItemDTO) {
        self.usecase.add(favoriteItem: favoriteItem)
    }
    
    func remove(favoriteItem: FavoriteItemDTO) {
        self.usecase.remove(favoriteItem: favoriteItem)
    }
}