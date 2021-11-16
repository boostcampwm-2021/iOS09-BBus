//
//  BusRouteViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine
import CoreGraphics

typealias BusStationInfo = (speed: Int, afterSpeed: Int?, count: Int, title: String, description: String, transYn: String, arsId: String)
typealias BusPosInfo = (location: CGFloat, number: String, congestion: BusCongestion, islower: Bool)

class BusRouteViewModel {

    private let usecase: BusRouteUsecase
    private var cancellables: Set<AnyCancellable>
    private let busRouteId: Int
    @Published var header: BusRouteDTO?
    @Published var bodys: [BusStationInfo] = []
    @Published var buses: [BusPosInfo] = []

    init(usecase: BusRouteUsecase, busRouteId: Int) {
        self.usecase = usecase
        self.busRouteId = busRouteId
        self.cancellables = []
        self.bindingHeaderInfo()
        self.bindingBodysInfo()
        self.bindingBusesPosInfo()
    }

    private func bindingHeaderInfo() {
        self.usecase.$header
            .receive(on: BusRouteUsecase.queue)
            .sink(receiveValue: { header in
                self.header = header
            })
            .store(in: &self.cancellables)
    }

    private func bindingBodysInfo() {
        self.usecase.$bodys
            .receive(on: BusRouteUsecase.queue)
            .sink(receiveValue: { bodys in
                self.convertBusStationInfo(with: bodys)
            })
            .store(in: &self.cancellables)
    }

    private func bindingBusesPosInfo() {
        self.usecase.$buses
            .receive(on: BusRouteUsecase.queue)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { buses in
                self.convertBusPosInfo(with: buses)
            })
            .store(in: &self.cancellables)
    }

    private func convertBusPos(order: Int, sect: String, fullSect: String) -> CGFloat {
        let order = CGFloat(order-1)
        let sect = CGFloat((sect as NSString).floatValue)
        let fullSect = CGFloat((fullSect as NSString).floatValue)
        return order + (sect/fullSect)
    }

    private func busNumber(from fullBusNumber: String) -> String {
        let startIndex = fullBusNumber.index(fullBusNumber.startIndex, offsetBy: 5)
        let endIndex = fullBusNumber.endIndex
        return String(fullBusNumber[startIndex..<endIndex])
    }

    private func convertBusStationInfo(with bodys: [StationByRouteListDTO]) {
        var bodysResult: [BusStationInfo] = []
        for (idx, body) in bodys.enumerated() {
            let info: BusStationInfo
            info.speed = body.sectionSpeed
            info.afterSpeed = idx+1 == bodys.count ? nil : bodys[idx+1].sectionSpeed
            info.count = bodys.count
            info.title = body.stationName
            info.description = "\(body.arsId)  |  \(body.beginTm)-\(body.lastTm)"
            info.transYn = body.transYn
            info.arsId = body.arsId
            bodysResult.append(info)
        }
        self.bodys = bodysResult
    }

    private func convertBusPosInfo(with buses: [BusPosByRtidDTO]) {
        var busesResult: [BusPosInfo] = []
        buses.forEach { bus in
            let info: BusPosInfo
            info.location = self.convertBusPos(order: bus.sectionOrder,
                                               sect: bus.sectDist,
                                               fullSect: bus.fullSectDist)
            info.number = self.busNumber(from: bus.plainNumber)
            info.congestion = BusCongestion(rawValue: bus.congestion) ?? .normal
            info.islower = (bus.busType == 1)
            busesResult.append(info)
        }
        self.buses = busesResult
    }

    func fetch() {
        self.usecase.searchHeader(busRouteId: self.busRouteId)
        self.usecase.fetchRouteList(busRouteId: self.busRouteId)
        self.usecase.fetchBusPosList(busRouteId: self.busRouteId)
    }

    func refreshBusPos() {
        self.usecase.fetchBusPosList(busRouteId: self.busRouteId)
    }
}
