//
//  StationViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class StationViewModel {
    
    let usecase: StationUsecase
    private let arsId: String
    private var cancellables: Set<AnyCancellable>
    @Published private(set) var infoBuses = [BBusRouteType: [StationByUidItemDTO]]()
    @Published private(set) var noInfoBuses = [BBusRouteType: [StationByUidItemDTO]]()
    
    
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
        var infoBuses: [BBusRouteType: [StationByUidItemDTO]] = [:]
        var noInfoBuses: [BBusRouteType: [StationByUidItemDTO]] = [:]
        buses.forEach() { bus in
            guard let routeType = BBusRouteType(rawValue: Int(bus.routeType) ?? 0) else {
                return print(bus.routeType)
            }
            if checkInfo(with: bus) {
                infoBuses.updateValue((infoBuses[routeType] ?? []) + [bus], forKey: routeType)
            }
            else {
                noInfoBuses.updateValue((noInfoBuses[routeType] ?? []) + [bus], forKey: routeType)
            }
        }
        self.infoBuses = infoBuses
        self.noInfoBuses = noInfoBuses
    }
    
    private func checkInfo(with bus: StationByUidItemDTO) -> Bool {
        let noInfoMessages = ["운행종료", "출발대기"]
        return !noInfoMessages.contains(bus.firstBusArriveRemainTime)
    }
}
