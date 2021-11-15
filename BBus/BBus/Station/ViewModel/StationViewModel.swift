//
//  StationViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

enum BusCongestion: Int {
    case relaxed = 3, normal, confusion, veryCrowded
    
    func toString() -> String {
        switch self {
        case .relaxed : return "여유"
        case .normal : return "보통"
        case .confusion : return "혼잡"
        case .veryCrowded : return "매우 혼잡"
        }
    }
}

struct BusRemainTime {
    let seconds: Int?
    let message: String?
    
    init(arriveRemainTime: String) {
        let times = arriveRemainTime.components(separatedBy: ["분", "초"])
        switch times.count {
        case 3 :
            self.seconds = 60 * (Int(times[0]) ?? 0) + (Int(times[1]) ?? 0)
            self.message = nil
        case 2:
            if arriveRemainTime.contains("분") {
                self.seconds = 60 * (Int(times[0]) ?? 0)
            }
            else {
                self.seconds = Int(times[1]) ?? 0
            }
            self.message = nil
        default :
            self.seconds = nil
            self.message = arriveRemainTime
        }
    }
    
    func toString() -> String? {
        if let time = self.seconds {
            let minutes = time / 60
            let seconds = time % 60
            return "\(minutes)분 \(seconds)초"
        }
        else {
            return self.checkInfo() ? self.message : nil
        }
    }
    
    func checkInfo() -> Bool {
        guard let message = self.message else { return true }
        let noInfoMessages = ["운행종료", "출발대기"]
        return !noInfoMessages.contains(message)
    }
}

typealias BusArriveInfo = (firstBusArriveRemainTime: BusRemainTime?, firstBusRelativePosition: String?, secondBusArriveRemainTime: BusRemainTime?, secondBusRelativePosition: String?, arsId: String, stationOrd: Int, busRouteId: Int, congestion: BusCongestion?, nextStation: String, busNumber: String, routeType: BBusRouteType)


class StationViewModel {
    
    let usecase: StationUsecase
    private let arsId: String
    private var cancellables: Set<AnyCancellable>
    @Published private(set) var busKeys: [BBusRouteType]
    private(set) var infoBuses = [BBusRouteType: [BusArriveInfo]]()
    private(set) var noInfoBuses = [BBusRouteType: [BusArriveInfo]]()
    private(set) var favoriteItems = [FavoriteItem]()
    @Published private(set) var nextStation: String? = nil
    
    init(usecase: StationUsecase, arsId: String) {
        self.usecase = usecase
        self.arsId = arsId
        self.cancellables = []
        self.busKeys = []
        self.binding()
        self.usecase.stationInfoWillLoad(with: arsId)
        self.usecase.refreshInfo(about: arsId)
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
            }, receiveValue: { arriveInfo in
                guard arriveInfo.count > 0 else { return }
                self.nextStation = arriveInfo[0].nextStation
                self.classifyByRouteType(with: arriveInfo)
            })
            .store(in: &self.cancellables)
    }
    
    private func bindingFavoriteItems() {
        self.usecase.$favoriteItems
            .receive(on: StationUsecase.queue)
            .sink(receiveValue: { items in
                self.favoriteItems = items.filter() { $0.arsId == self.arsId }
            })
            .store(in: &self.cancellables)
    }

    private func classifyByRouteType(with buses: [StationByUidItemDTO]) {
        var infoBuses: [BBusRouteType: [BusArriveInfo]] = [:]
        var noInfoBuses: [BBusRouteType: [BusArriveInfo]] = [:]
        buses.forEach() { bus in
            guard let routeType = BBusRouteType(rawValue: Int(bus.routeType) ?? 0) else { return print(bus.routeType) }
            
            let info: BusArriveInfo
            info.routeType = routeType
            info.congestion = BusCongestion(rawValue: bus.congestion)
            
            info.nextStation = bus.nextStation
            info.busNumber = bus.busNumber
            info.arsId = bus.arsId
            info.stationOrd = bus.stationOrd
            info.busRouteId = bus.busRouteId
            
            let timeAndPositionInfo1 = self.separateTimeAndPositionInfo(with: bus.firstBusArriveRemainTime)
            if timeAndPositionInfo1.time.checkInfo() {
                info.firstBusArriveRemainTime = timeAndPositionInfo1.time
                info.firstBusRelativePosition = timeAndPositionInfo1.position
                
                let timeAndPositionInfo2 = self.separateTimeAndPositionInfo(with: bus.secondBusArriveRemainTime)
                info.secondBusArriveRemainTime = timeAndPositionInfo2.time
                info.secondBusRelativePosition = timeAndPositionInfo2.position
                
                infoBuses.updateValue((infoBuses[routeType] ?? []) + [info], forKey: routeType)
            }
            else {
                info.firstBusArriveRemainTime = nil
                info.firstBusRelativePosition = nil
                info.secondBusArriveRemainTime = nil
                info.secondBusRelativePosition = nil
                
                noInfoBuses.updateValue((noInfoBuses[routeType] ?? []) + [info], forKey: routeType)
            }
        }
        self.infoBuses = infoBuses
        self.noInfoBuses = noInfoBuses
        
        let keys = Array(infoBuses.keys).sorted(by: { $0.rawValue < $1.rawValue }) + Array(noInfoBuses.keys).sorted(by: { $0.rawValue < $1.rawValue })
        self.busKeys = keys
    }
    
    private func checkInfo(with bus: StationByUidItemDTO) -> Bool {
        let noInfoMessages = ["운행종료", "출발대기"]
        return !noInfoMessages.contains(bus.firstBusArriveRemainTime)
    }
    
    private func separateTimeAndPositionInfo(with info: String) -> (time: BusRemainTime, position: String?) {
        let components = info.components(separatedBy: ["[", "]"])
        if components.count > 1 {
            return (time: BusRemainTime(arriveRemainTime: components[0]), position: components[1])
        }
        else {
            return (time: BusRemainTime(arriveRemainTime: components[0]), position: nil)
        }
    }
    
    func add(favoriteItem: FavoriteItem) {
        self.usecase.add(favoriteItem: favoriteItem)
    }
    
    func remove(favoriteItem: FavoriteItem) {
        self.usecase.remove(favoriteItem: favoriteItem)
    }
}
