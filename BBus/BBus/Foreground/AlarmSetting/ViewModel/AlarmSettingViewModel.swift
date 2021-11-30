//
//  AlarmSettingViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class AlarmSettingViewModel {
    
    let apiUseCase: AlarmSettingAPIUseCase
    let calculateUseCase: AlarmSettingCalculateUseCase
    let stationId: Int
    let busRouteId: Int
    let stationOrd: Int
    private let arsId: String
    let routeType: RouteType?
    let busName: String
    @Published private(set) var busArriveInfos: AlarmSettingBusArriveInfos
    @Published private(set) var busStationInfos: [AlarmSettingBusStationInfo]?
    @Published private(set) var errorMessage: String?
    @Published private(set) var loaderActiveStatus: Bool
    private var cancellables: Set<AnyCancellable>
    private var observer: NSObjectProtocol?
    
    init(apiUseCase: AlarmSettingAPIUseCase, calculateUseCase: AlarmSettingCalculateUseCase, stationId: Int, busRouteId: Int, stationOrd: Int, arsId: String, routeType: RouteType?, busName: String) {
        self.apiUseCase = apiUseCase
        self.calculateUseCase = calculateUseCase
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
        self.loaderActiveStatus = true
        self.bind()
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
        self.bindBusArriveInfo()
    }
    
    private func bind() {
        self.bindBusArriveInfo()
        self.bindBusStationsInfo()
        self.bindAlarmSettingViewModelInfo()
    }
    
    private func bindBusArriveInfo() {
        self.apiUseCase.busArriveInfoWillLoaded(stId: "\(self.stationId)",
                                             busRouteId: "\(self.busRouteId)",
                                             ord: "\(self.stationOrd)")
            .first()
            .receive(on: DispatchQueue.global())
            .compactMap({$0})
            .map({ data in
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
                return AlarmSettingBusArriveInfos(arriveInfos: arriveInfos, changedByTimer: false)
            })
            .assign(to: &self.$busArriveInfos)
    }
    
    private func bindBusStationsInfo() {
        let initInfo: AlarmSettingBusStationInfo
        initInfo.estimatedTime = 0
        initInfo.arsId = ""
        initInfo.name = ""
        initInfo.ord = 0
        
        self.apiUseCase.busStationsInfoWillLoaded(busRouetId: "\(self.busRouteId)", arsId: self.arsId)
            .first()
            .receive(on: DispatchQueue.global())
            .compactMap({ [weak self] result -> [StationByRouteListDTO]? in
                if result == nil { self?.busStationInfos = nil }
                return result
            })
            .flatMap({ result in
                return result.publisher
            })
            .scan(initInfo, { before, info in
                let alarmSettingInfo: AlarmSettingBusStationInfo
                alarmSettingInfo.arsId = info.arsId
                alarmSettingInfo.estimatedTime = before.estimatedTime + (before.arsId != "" ? self.calculateUseCase.averageSectionTime(speed: info.sectionSpeed, distance: info.fullSectionDistance) : 0)
                alarmSettingInfo.name = info.stationName
                alarmSettingInfo.ord = info.sequence
                return alarmSettingInfo
            })
            .collect()
            .map { $0 as [AlarmSettingBusStationInfo]? }
            .assign(to: &self.$busStationInfos)
    }
    
    private func bindAlarmSettingViewModelInfo() {
        self.$busArriveInfos.compactMap({$0})
            .combineLatest(self.$busStationInfos.dropFirst())
            .filter({ [weak self] _ in
                guard let self = self else { return false }
                return self.loaderActiveStatus
            })
            .sink(receiveValue: { _ in
                self.loaderActiveStatus = false
            })
            .store(in: &self.cancellables)
    }
    
    func activateLoaderActiveStatus() {
        self.loaderActiveStatus = true
    }
}
