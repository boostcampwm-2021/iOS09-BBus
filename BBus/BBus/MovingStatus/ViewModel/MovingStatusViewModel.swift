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
typealias StationInfo = (speed: Int, afterSpeed: Int?, count: Int, title: String, sectTime: Int)

final class MovingStatusViewModel {

    private let usecase: MovingStatusUsecase
    private var cancellables: Set<AnyCancellable>
    private let busRouteId: Int
    private let fromArsId: String
    private let toArsId: String
    private var startOrd: Int?
    @Published var busInfo: BusInfo?
    @Published var stationInfos: [StationInfo] = []
    @Published var buses: [BusPosByRtidDTO] = []
    @Published var remainingTime: Int?
    @Published var remainingStation: Int?

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
                self?.buses = buses
            }
            .store(in: &self.cancellables)
    }

    private func convertBusInfo(header: BusRouteDTO?) {
        guard let header = header else { return }

        let busInfo: BusInfo
        busInfo.busName = header.busRouteName
        busInfo.type = header.routeType

        self.busInfo = busInfo
    }

    // GPS 를 통해 특정 버스를 찾은 경우 사용되는 메소드
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
        self.startOrd = stations.first?.sectionOrd

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

        self.stationInfos = stationsResult
        self.remainingTime = totalTime
    }

    static func averageSectionTime(speed: Int, distance: Int) -> Int {
        let result = Double(distance)/21*0.06
        return Int(ceil(result))
    }

    func fetch() {
        self.usecase.searchHeader(busRouteId: self.busRouteId)
        self.usecase.fetchRouteList(busRouteId: self.busRouteId)
    }
}
