//
//  MovingStatusViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine
import CoreGraphics

typealias BusInfo = (busName: String, type: RouteType)
typealias BoardedBus = (location: CGFloat, remainStation: Int?)
typealias StationInfo = (speed: Int, afterSpeed: Int?, count: Int, title: String, sectTime: Int)

final class MovingStatusViewModel {

    let apiUseCase: MovingStatusAPIUsable
    let calculateUseCase: MovingStatusCalculatable
    private var cancellables: Set<AnyCancellable>
    private let busRouteId: Int
    private let fromArsId: String
    private let toArsId: String
    private var startOrd: Int?
    private var currentOrd: Int?
    private(set) var isFolded: Bool = false
    @Published private(set) var isterminated: Bool = false
    @Published private(set) var busInfo: BusInfo?
    @Published private(set) var stationInfos: [StationInfo] = []
    @Published private(set) var buses: [BusPosByRtidDTO] = []
    @Published private(set) var remainingTime: Int?
    @Published private(set) var remainingStation: Int?
    @Published private(set) var boardedBus: BoardedBus?
    @Published private(set) var message: String?
    @Published private(set) var stopLoader: Bool = false
    @Published private(set) var networkError: Error?

    init(apiUseCase: MovingStatusAPIUsable, calculateUseCase: MovingStatusCalculatable, busRouteId: Int, fromArsId: String, toArsId: String) {
        self.apiUseCase = apiUseCase
        self.calculateUseCase = calculateUseCase
        self.busRouteId = busRouteId
        self.fromArsId = fromArsId
        self.toArsId = toArsId
        self.message = nil
        self.cancellables = []
        self.binding()
        self.configureObserver()
    }
    
    func updateAPI() {
        self.bindBusesPosInfo()
    }

    func fold() {
        self.isFolded = true
    }

    func unfold() {
        self.isFolded = false
    }
    
    // Background 내에서 GPS 변화시 불리는 함수
    func findBoardBus(gpsY: Double, gpsX: Double) {
        if buses.isEmpty { return }
        if stationInfos.isEmpty { return }

        for bus in buses {
            if self.calculateUseCase.isOnBoard(gpsY: gpsY, gpsX: gpsX, busY: bus.gpsY, busX: bus.gpsX) {
                self.updateRemainingStation(bus: bus)
                self.updateBoardBus(bus: bus)
                self.updateRemainingTime(bus: bus)
                break
            }
        }
    }
    
    private func configureObserver() {
        NotificationCenter.default.addObserver(forName: .fifteenSecondsPassed, object: nil, queue: .none) { [weak self] _ in
            guard let self = self else { return }
            if !(self.isterminated) {
                self.updateAPI()
            }
        }
    }

    private func binding() {
        self.bindLoader()
        self.bindHeaderInfo()
        self.bindStationsInfo()
        self.bindBusesPosInfo()
    }

    private func bindHeaderInfo() {
        self.apiUseCase.searchHeader(busRouteId: self.busRouteId)
            .receive(on: DispatchQueue.global())
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .sink(receiveValue: { [weak self] header in
                guard let self = self,
                      let header = header else { return }
                
                self.busInfo = self.calculateUseCase.convertBusInfo(header: header)
            })
            .store(in: &self.cancellables)
    }

    private func bindStationsInfo() {
        self.apiUseCase.fetchRouteList(busRouteId: self.busRouteId)
            .receive(on: DispatchQueue.global())
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .sink(receiveValue: { [weak self] stations in
                self?.convertBusStations(with: stations)
            })
            .store(in: &self.cancellables)
    }

    private func bindBusesPosInfo() {
        self.apiUseCase.fetchBusPosList(busRouteId: self.busRouteId)
            .receive(on: DispatchQueue.global())
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .sink { [weak self] buses in
                guard let self = self,
                      let currentOrd = self.currentOrd,
                      let startOrd = self.startOrd else { return }
                let count = self.stationInfos.count

                self.buses = self.calculateUseCase.filteredBuses(from: buses,
                                                                 startOrd: startOrd,
                                                                 currentOrd: currentOrd,
                                                                 count: count)
                
                // Test 로직
                guard let y = self.buses.first?.gpsY,
                      let x = self.buses.first?.gpsX else { return }

                self.findBoardBus(gpsY: y, gpsX: x)
            }
            .store(in: &self.cancellables)
    }
    
    private func bindLoader() {
        self.$busInfo.zip(self.$stationInfos)
            .dropFirst()
            .sink(receiveValue: { _ in
                self.stopLoader = true
            })
            .store(in: &self.cancellables)
    }

    private func updateRemainingStation(bus: BusPosByRtidDTO) {
        guard let startOrd = self.startOrd else { return }
        let remainStation = self.calculateUseCase.remainStation(bus: bus,
                                                                startOrd: startOrd,
                                                                count: self.stationInfos.count)

        if self.remainingStation != remainStation {
            self.pushAlarm(remainStation: remainStation)
            self.remainingStation = remainStation
        }
    }

    private func pushAlarm(remainStation: Int) {
        let result = self.calculateUseCase.pushAlarmMessage(remainStation: remainStation)
        guard let message = result.message else { return }
        
        self.message = message
        if result.terminated {
            self.isterminated = true
        }
    }

    private func updateRemainingTime(bus: BusPosByRtidDTO) {
        guard let startOrd = self.startOrd,
              let boardedBus = self.boardedBus else { return }

        self.remainingTime = self.calculateUseCase.remainTime(bus: bus,
                                                              stations: self.stationInfos,
                                                              startOrd: startOrd,
                                                              boardedBus: boardedBus)
    }

    private func updateBoardBus(bus: BusPosByRtidDTO) {
        guard let startOrd = self.startOrd else { return }
        self.currentOrd = bus.sectionOrder
        let boardedBus: BoardedBus
        boardedBus.location = CGFloat(self.calculateUseCase.convertBusPos(startOrd: startOrd,
                                                                          order: bus.sectionOrder,
                                                                          sect: bus.sectDist,
                                                                          fullSect: bus.fullSectDist))
        boardedBus.remainStation = self.remainingStation
        self.boardedBus = boardedBus
    }
    
    private func convertBusStations(with stations: [StationByRouteListDTO]) {
        guard let startIndex = self.calculateUseCase.stationIndex(with: self.fromArsId, with: stations) else { return }
        guard let endIndex = self.calculateUseCase.stationIndex(with: self.toArsId, with: stations) else { return }
        
        let stations = Array(stations[startIndex...endIndex])
        self.startOrd = stations.first?.sequence
        self.currentOrd = self.startOrd
        
        let results = self.calculateUseCase.filteredStations(from: stations)
        self.stationInfos = results.stations
        self.remainingTime = results.time
    }
}
