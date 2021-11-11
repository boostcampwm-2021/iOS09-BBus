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

class StationViewModel {
    
    typealias BusArriveInfo = (firstBusArriveRemainTime: String, firstBusRelativePosition: String?, secondBusArriveRemainTime: String, secondBusRelativePosition: String?, arsId: String, busRouteId: Int, congestion: BusCongestion, nextStation: String, busNumber: String, routeType: BBusRouteType)
    
    let usecase: StationUsecase
    private let arsId: String
    private var cancellables: Set<AnyCancellable>
    @Published private(set) var infoBuses = [BBusRouteType: [BusArriveInfo]]()
    @Published private(set) var noInfoBuses = [BBusRouteType: [BusArriveInfo]]()
    
    init(usecase: StationUsecase, arsId: String) {
        self.usecase = usecase
        self.arsId = arsId
        self.cancellables = []
        self.bindingBusArriveInfo()
        self.usecase.stationInfoWillLoad(with: arsId)
        self.usecase.refreshInfo(about: arsId)
    }
    
    func bindingBusArriveInfo() {
        self.usecase.$busArriveInfo
            .receive(on: StationUsecase.thread)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { arriveInfo in
                self.classifyByRouteType(with: arriveInfo)
//                self.infoBuses.forEach({ key, value in
//                    print(key.rawValue)
//                    print(value)
//                })
//                self.noInfoBuses.forEach({ key, value in
//                    print(key.rawValue)
//                    print(value)
//                })
            })
            .store(in: &self.cancellables)
    }

    private func classifyByRouteType(with buses: [StationByUidItemDTO]) {
        var infoBuses: [BBusRouteType: [BusArriveInfo]] = [:]
        var noInfoBuses: [BBusRouteType: [BusArriveInfo]] = [:]
        buses.forEach() { bus in
            guard let routeType = BBusRouteType(rawValue: Int(bus.routeType) ?? 0),
                  let congestion = BusCongestion(rawValue: bus.congestion) else { return print(bus.routeType) }
            let info: BusArriveInfo
            info.routeType = routeType
            info.congestion = congestion
            let timeAndPositionInfo1 = self.separateTimeAndPositionInfo(with: bus.firstBusArriveRemainTime)
            info.firstBusArriveRemainTime = timeAndPositionInfo1.time
            info.firstBusRelativePosition = timeAndPositionInfo1.position
            let timeAndPositionInfo2 = self.separateTimeAndPositionInfo(with: bus.secondBusArriveRemainTime)
            info.secondBusArriveRemainTime = timeAndPositionInfo2.time
            info.secondBusRelativePosition = timeAndPositionInfo2.position
            info.nextStation = bus.nextStation
            info.busNumber = bus.busNumber
            info.arsId = bus.arsId
            info.busRouteId = bus.busRouteId
            
            if checkInfo(with: bus) {
                infoBuses.updateValue((infoBuses[routeType] ?? []) + [info], forKey: routeType)
            }
            else {
                noInfoBuses.updateValue((noInfoBuses[routeType] ?? []) + [info], forKey: routeType)
            }
        }
        self.infoBuses = infoBuses
        self.noInfoBuses = noInfoBuses
    }
    
    private func checkInfo(with bus: StationByUidItemDTO) -> Bool {
        let noInfoMessages = ["운행종료", "출발대기"]
        return !noInfoMessages.contains(bus.firstBusArriveRemainTime)
    }
    
    private func separateTimeAndPositionInfo(with info: String) -> (time: String, position: String?) {
        let components = info.components(separatedBy: ["[", "]"])
        if components.count > 1 {
            return (time: components.first ?? "", position: components[1])
        }
        else {
            return (time: components.first ?? "", position: nil)
        }
    }
}
