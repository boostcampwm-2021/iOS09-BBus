//
//  AlarmSettingViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class AlarmSettingViewModel {
    
    let useCase: AlarmSettingUseCase
    private let stationId: Int
    private let busRouteId: Int
    private let stationOrd: Int
    @Published private(set) var busArriveInfos: [AlarmSettingBusArriveInfo]
    private var cancellables: Set<AnyCancellable>
    
    init(useCase: AlarmSettingUseCase, stationId: Int, busRouteId: Int, stationOrd: Int) {
        self.useCase = useCase
        self.stationId = stationId
        self.busRouteId = busRouteId
        self.stationOrd = stationOrd
        self.cancellables = []
        self.busArriveInfos = []
        self.bindingBusArriveInfo()
        self.refresh()
        self.configureObserver()
    }
    
    private func configureObserver() {
        NotificationCenter.default.addObserver(forName: .oneSecondPassed, object: nil, queue: .main) { _ in
            self.descendTime()
        }
    }
    
    private func descendTime() {
        self.busArriveInfos = self.busArriveInfos.map {
            var arriveInfo = $0
            arriveInfo.arriveRemainTime?.descend()
            return arriveInfo
        }
    }
    
    func refresh() {
        self.useCase.busArriveInfoWillLoaded(stId: "\(self.stationId)",
                                             busRouteId: "\(self.busRouteId)",
                                             ord: "\(self.stationOrd)")
    }
    
    func bindingBusArriveInfo() {
        self.useCase.$busArriveInfo
            .receive(on: AlarmSettingUseCase.queue)
            .sink(receiveValue: { data in
                guard let data = data else { return }
                var arriveInfos: [AlarmSettingBusArriveInfo] = []
                arriveInfos.append(AlarmSettingBusArriveInfo(busArriveRemainTime: data.firstBusArriveRemainTime,
                                                             congestion: data.firstBusCongestion,
                                                             currentStation: data.firstBusCurrentStation,
                                                             plainNumber: data.firstBusPlainNumber))
                arriveInfos.append(AlarmSettingBusArriveInfo(busArriveRemainTime: data.secondBusArriveRemainTime,
                                                             congestion: data.secondBusCongestion,
                                                             currentStation: data.secondBusCurrentStation,
                                                             plainNumber: data.secondBusPlainNumber))
                self.busArriveInfos = arriveInfos
            })
            .store(in: &self.cancellables)
        
    }
}
