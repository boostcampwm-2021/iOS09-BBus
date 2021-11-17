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

    private let usecase: MovingStatusUsecase
    private var cancellables: Set<AnyCancellable>
    private let busRouteId: Int
    private let fromArsId: String
    private let toArsId: String
    private var startOrd: Int? // 2
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
        self.bindingHeaderInfo()
        self.bindingStationsInfo()
        self.bindingBusesPosInfo()
    }

    private func bindingHeaderInfo() {
        self.usecase.$header
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { [weak self] header in
                self?.convertBusInfo(header: header)
            })
            .store(in: &self.cancellables)
    }

    private func bindingStationsInfo() {
        self.usecase.$stations
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { [weak self] stations in
                self?.convertBusStations(with: stations)
            })
            .store(in: &self.cancellables)
    }

    private func bindingBusesPosInfo() {
        self.usecase.$buses
            .receive(on: MovingStatusUsecase.queue)
            .sink { [weak self] buses in
                self?.buses = buses // 5
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

    // GPS 를 통해 현재 위치를 찾은 경우 사용되는 메소드
    func findBoardBus(gpsY: Double, gpsX: Double) {
        if buses.isEmpty { return }
        if stationInfos.isEmpty { return }

        for bus in buses {
            if self.onBoard(gpsY: gpsY, gpsX: gpsX, busY: bus.gpsY, busX: bus.gpsX) {
                self.updateRemainingStation(bus: bus)
                self.updateRemainingTime(bus: bus)
                self.updateBoardBus(bus: bus)
                break
            }
        }
    }

    // 남은 정거장 수 업데이트 로직
    private func updateRemainingStation(bus: BusPosByRtidDTO) {
        guard let startOrd = self.startOrd else { return }
        self.remainingStation = (self.stationInfos.count - 1) - (bus.sectionOrder - startOrd) // 6
    }

    // 남은 시간 업데이트 로직
    private func updateRemainingTime(bus: BusPosByRtidDTO) {
        guard let startOrd = self.startOrd else { return }
        let currentIdx = (bus.sectionOrder - startOrd)
        var totalRemainTime = 0
        for index in currentIdx...self.stationInfos.count-1 {
            totalRemainTime += self.stationInfos[index].sectTime
        }

        let currentLocation = self.convertBusPos(startOrd: startOrd,
                                                 order: bus.sectionOrder,
                                                 sect: bus.sectDist,
                                                 fullSect: bus.fullSectDist)
        let extraPersent = Double(currentLocation) - Double(currentIdx)
        let extraTime = extraPersent * Double(self.stationInfos[currentIdx].sectTime)
        totalRemainTime -= Int(ceil(extraTime))

        self.remainingTime = totalRemainTime // 7
    }

    // 탑승한 버스 업데이트 로직
    private func updateBoardBus(bus: BusPosByRtidDTO) {
        guard let startOrd = self.startOrd else { return }
        let boardedBus: BoardedBus
        boardedBus.location = self.convertBusPos(startOrd: startOrd,
                                                 order: bus.sectionOrder,
                                                 sect: bus.sectDist,
                                                 fullSect: bus.fullSectDist)
        boardedBus.remainStation = self.remainingStation
        self.boardedBus = boardedBus // 8
    }

    // Bus - 유저간 거리 측정 로직
    func onBoard(gpsY: Double, gpsX: Double, busY: Double, busX: Double) -> Bool {
        return true
    }

    // 현재 버스의 노선도 위치 반환
    private func convertBusPos(startOrd: Int, order: Int, sect: String, fullSect: String) -> CGFloat {
        let order = CGFloat(order-1-startOrd)
        let sect = CGFloat((sect as NSString).floatValue)
        let fullSect = CGFloat((fullSect as NSString).floatValue)
        return order + (sect/fullSect)
    }

    private func convertBusStations(with stations: [StationByRouteListDTO]) {
        guard let startIndex = stations.firstIndex(where: { $0.arsId == self.fromArsId }) else { return }
        guard let endIndex = stations.firstIndex(where: { $0.arsId == self.toArsId }) else { return }

        var stationsResult: [StationInfo] = []
        var totalTime: Int = 0
        let stations = Array(stations[startIndex...endIndex])
        self.startOrd = stations.first?.sectionOrd // 2

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
        self.usecase.fetchBusPosList(busRouteId: self.busRouteId)
    }
}
