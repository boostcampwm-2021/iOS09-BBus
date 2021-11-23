//
//  MovingStatusViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine
import CoreGraphics
import CoreLocation

typealias BusInfo = (busName: String, type: RouteType)
typealias BoardedBus = (location: CGFloat, remainStation: Int?)
typealias StationInfo = (speed: Int, afterSpeed: Int?, count: Int, title: String, sectTime: Int)

final class MovingStatusViewModel {

    let usecase: MovingStatusUsecase
    private var cancellables: Set<AnyCancellable>
    private let busRouteId: Int
    private let fromArsId: String
    private let toArsId: String
    private var startOrd: Int? // 2
    private var currentOrd: Int?
    @Published var isterminated: Bool = false
    @Published var busInfo: BusInfo? // 1
    @Published var stationInfos: [StationInfo] = [] // 3
    @Published var buses: [BusPosByRtidDTO] = [] // 5
    @Published var remainingTime: Int? // 4, 7
    @Published var remainingStation: Int? // 6
    @Published var boardedBus: BoardedBus? // 8

    init(usecase: MovingStatusUsecase, busRouteId: Int, fromArsId: String, toArsId: String) {
        self.usecase = usecase
        self.busRouteId = busRouteId
        self.fromArsId = fromArsId
        self.toArsId = toArsId
        self.cancellables = []
        self.bindHeaderInfo()
        self.bindStationsInfo()
        self.bindBusesPosInfo()
        self.configureObserver()
    }
    
    private func configureObserver() {
        NotificationCenter.default.addObserver(forName: .fifteenSecondsPassed, object: nil, queue: .none) { _ in
            if !self.isterminated {
                self.updateAPI()
            }
        }
    }

    private func bindHeaderInfo() {
        self.usecase.$header
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { [weak self] header in
                self?.convertBusInfo(header: header)
            })
            .store(in: &self.cancellables)
    }

    private func bindStationsInfo() {
        self.usecase.$stations
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { [weak self] stations in
                self?.convertBusStations(with: stations)
            })
            .store(in: &self.cancellables)
    }

    private func bindBusesPosInfo() {
        self.usecase.$buses
            .receive(on: MovingStatusUsecase.queue)
            .sink { [weak self] buses in
                guard let currentOrd = self?.currentOrd,
                      let startOrd = self?.startOrd,
                      let count = self?.stationInfos.count else { return }

                self?.buses = buses.filter { $0.sectionOrder >= currentOrd && $0.sectionOrder < startOrd + count } // 5
                // Test 로직
                guard let y = self?.buses.first?.gpsY,
                      let x = self?.buses.first?.gpsX else { return }

                self?.findBoardBus(gpsY: y, gpsX: x)
            }
            .store(in: &self.cancellables)
    }

    private func convertBusInfo(header: BusRouteDTO?) {
        guard let header = header else { return }

        let busInfo: BusInfo
        busInfo.busName = header.busRouteName
        busInfo.type = header.routeType

        self.busInfo = busInfo // 1
    }

    // Background 내에서 GPS 변화시 불리는 함수
    func findBoardBus(gpsY: Double, gpsX: Double) {
        if buses.isEmpty { return }
        if stationInfos.isEmpty { return }

        for bus in buses {
            if self.isOnBoard(gpsY: gpsY, gpsX: gpsX, busY: bus.gpsY, busX: bus.gpsX) {
                self.updateRemainingStation(bus: bus)
                self.updateBoardBus(bus: bus)
                self.updateRemainingTime(bus: bus)
                break
            }
        }
    }

    // 남은 정거장 수 업데이트 로직
    private func updateRemainingStation(bus: BusPosByRtidDTO) {
        guard let startOrd = self.startOrd else { return }
        let remainStation = (self.stationInfos.count - 1) - (bus.sectionOrder - startOrd) // 6

        if self.remainingStation != remainStation {
            self.pushAlarm(remainStation: remainStation)
            self.remainingStation = remainStation
        }
    }

    // 정거장 수가 변화되었을 경우 알람 푸쉬 로직
    private func pushAlarm(remainStation: Int) {
        if remainStation < 4 && remainStation > 1 {
            // TODO: push 알림 보내기 구현
            print("\(remainStation) 정거장 남았어요!")
        }
        else if remainStation == 1 {
            // TODO: push 알림 보내기 구현
            print("다음 정거장에 내려야 합니다!")
        }
        else if remainStation <= 0 {
            // TODO: push 알림 보내기 구현
            print("하차 정거장에 도착하여 알람이 종료되었습니다.")
            self.isterminated = true
        }
    }

    // 남은 시간 업데이트 로직
    private func updateRemainingTime(bus: BusPosByRtidDTO) {
        guard let startOrd = self.startOrd,
              let boardedBus = self.boardedBus else { return }

        let currentIdx = (bus.sectionOrder - startOrd)
        var totalRemainTime = 0
        for index in currentIdx...self.stationInfos.count-1 {
            totalRemainTime += self.stationInfos[index].sectTime
        }

        let currentLocation = boardedBus.location
        let extraPersent = Double(currentLocation) - Double(currentIdx)
        let extraTime = extraPersent * Double(self.stationInfos[currentIdx].sectTime)
        totalRemainTime -= Int(ceil(extraTime))

        self.remainingTime = totalRemainTime // 7
    }

    // 탑승한 버스 업데이트 로직
    private func updateBoardBus(bus: BusPosByRtidDTO) {
        guard let startOrd = self.startOrd else { return }
        self.currentOrd = bus.sectionOrder
        let boardedBus: BoardedBus
        boardedBus.location = self.convertBusPos(startOrd: startOrd,
                                                 order: bus.sectionOrder,
                                                 sect: bus.sectDist,
                                                 fullSect: bus.fullSectDist)
        boardedBus.remainStation = self.remainingStation
        self.boardedBus = boardedBus // 8
    }

    // Bus - 유저간 거리 측정 로직
    func isOnBoard(gpsY: Double, gpsX: Double, busY: Double, busX: Double) -> Bool {
        let userLocation = CLLocation(latitude: gpsX, longitude: gpsY)
        let busLocation = CLLocation(latitude: busX, longitude: busY)
        let distanceInMeters = userLocation.distance(from: busLocation)
        print(distanceInMeters)
        
        return distanceInMeters <= 30.0
    }

    // 현재 버스의 노선도 위치 반환
    private func convertBusPos(startOrd: Int, order: Int, sect: String, fullSect: String) -> CGFloat {
        let order = CGFloat(order-1-startOrd)
        let sect = CGFloat((sect as NSString).floatValue)
        let fullSect = CGFloat((fullSect as NSString).floatValue)
        return order + (sect/fullSect) + 1
    }

    private func convertBusStations(with stations: [StationByRouteListDTO]) {
        guard let startIndex = stations.firstIndex(where: { $0.arsId == self.fromArsId }) else { return }
        guard let endIndex = stations.firstIndex(where: { $0.arsId == self.toArsId }) else { return }

        var stationsResult: [StationInfo] = []
        var totalTime: Int = 0
        let stations = Array(stations[startIndex...endIndex])
        self.startOrd = stations.first?.sectionOrd  // 2
        self.currentOrd = self.startOrd

        for (idx, station) in stations.enumerated() {
            let info: StationInfo
            info.speed = station.sectionSpeed
            info.afterSpeed = idx+1 == stations.count ? nil : stations[idx+1].sectionSpeed
            info.count = stations.count
            info.title = station.stationName
            info.sectTime = idx == 0 ? 0 : Self.averageSectionTime(speed: info.speed, distance: station.fullSectionDistance)

            stationsResult.append(info)
            totalTime += info.sectTime
        }

        self.stationInfos = stationsResult // 3
        self.remainingTime = totalTime // 4
    }

    static func averageSectionTime(speed: Int, distance: Int) -> Int {
        let result = Double(distance)/21*0.06
        return Int(ceil(result))
    }

    func fetch() {
        self.usecase.searchHeader(busRouteId: self.busRouteId)
        self.usecase.fetchRouteList(busRouteId: self.busRouteId)
        self.usecase.fetchBusPosList(busRouteId: self.busRouteId)
    }

    // 타이머가 일정주기로 실행
    func updateAPI() {
        self.usecase.fetchBusPosList(busRouteId: self.busRouteId) //고민 필요
    }
}
