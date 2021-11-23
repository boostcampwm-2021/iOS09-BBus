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
    let stationId: Int
    let busRouteId: Int
    let stationOrd: Int
    private let arsId: String
    let routeType: RouteType?
    let busName: String
    @Published private(set) var busArriveInfos: AlarmSettingBusArriveInfos
    @Published private(set) var busStationInfos: [AlarmSettingBusStationInfo]?
    @Published private(set) var errorMessage: String?
    private var cancellables: Set<AnyCancellable>
    private var observer: NSObjectProtocol?
    
    init(useCase: AlarmSettingUseCase, stationId: Int, busRouteId: Int, stationOrd: Int, arsId: String, routeType: RouteType?, busName: String) {
        self.useCase = useCase
        self.stationId = stationId
        self.busRouteId = busRouteId
        self.stationOrd = stationOrd
        self.arsId = arsId
        self.routeType = routeType
        self.busName = busName
        self.cancellables = []
        self.busArriveInfos = AlarmSettingBusArriveInfos(arriveInfos: [], changedByTimer: false)
        self.busStationInfos = nil
        self.errorMessage = nil
        self.binding()
        self.refresh()
        self.showBusStations()
    }
    
    func configureObserver() {
        self.observer = NotificationCenter.default.addObserver(forName: .oneSecondPassed, object: nil, queue: .main) { [weak self] _ in
            self?.busArriveInfos.desend()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .thirtySecondPassed, object: nil)
    }

    func cancelObserver() {
        guard let observer = self.observer else { return }
        NotificationCenter.default.removeObserver(observer)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refresh() {
        self.useCase.busArriveInfoWillLoaded(stId: "\(self.stationId)",
                                             busRouteId: "\(self.busRouteId)",
                                             ord: "\(self.stationOrd)")
    }
    
    private func showBusStations() {
        self.useCase.busStationsInfoWillLoaded(busRouetId: "\(self.busRouteId)", arsId: self.arsId)
    }
    
    private func binding() {
        self.bindingBusArriveInfo()
        self.bindingBusStationsInfo()
    }
    
    private func bindingBusArriveInfo() {
        self.useCase.$busArriveInfo
            .receive(on: AlarmSettingUseCase.queue)
            .sink(receiveValue: { [weak self] data in
                guard let data = data else { return }
                var arriveInfos: [AlarmSettingBusArriveInfo] = []
                arriveInfos.append(AlarmSettingBusArriveInfo(busArriveRemainTime: data.firstBusArriveRemainTime,
                                                             congestion: data.firstBusCongestion,
                                                             currentStation: data.firstBusCurrentStation,
                                                             plainNumber: data.firstBusPlainNumber,
                                                             vehicleId: data.firstBusVehicleId))

                arriveInfos.append(AlarmSettingBusArriveInfo(busArriveRemainTime: data.secondBusArriveRemainTime,
                                                             congestion: data.secondBusCongestion,
                                                             currentStation: data.secondBusCurrentStation,
                                                             plainNumber: data.secondBusPlainNumber,
                                                             vehicleId: data.secondBusVehicleId))
                self?.busArriveInfos = AlarmSettingBusArriveInfos(arriveInfos: arriveInfos, changedByTimer: false)
            })
            .store(in: &self.cancellables)
    }
    
    private func bindingBusStationsInfo() {
        self.useCase.$busStationsInfo
            .receive(on: AlarmSettingUseCase.queue)
            .sink(receiveValue: { [weak self] infos in
                self?.mappingStationsDTOtoAlarmSettingInfo()
            })
            .store(in: &self.cancellables)
    }
    
    private func mappingStationsDTOtoAlarmSettingInfo() {
        let initInfo: AlarmSettingBusStationInfo
        initInfo.estimatedTime = 0
        initInfo.arsId = ""
        initInfo.name = ""

        if let busStationsInfo = self.useCase.busStationsInfo {
            busStationsInfo.publisher
                .scan(initInfo, { before, info in
                    let alarmSettingInfo: AlarmSettingBusStationInfo
                    alarmSettingInfo.arsId = info.arsId
                    alarmSettingInfo.estimatedTime = before.estimatedTime + (before.arsId != "" ? MovingStatusViewModel.averageSectionTime(speed: info.sectionSpeed, distance: info.fullSectionDistance) : 0)
                    alarmSettingInfo.name = info.stationName
                    return alarmSettingInfo
                })
                .collect()
                .map { $0 as [AlarmSettingBusStationInfo]? }
                .assign(to: &self.$busStationInfos)
        }
        else {
            self.busStationInfos = nil
        }
    }
    
    func sendErrorMessage(_ message: String) {
        self.errorMessage = message
    }
}
