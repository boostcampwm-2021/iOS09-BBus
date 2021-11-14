//
//  BusRouteViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine
import CoreGraphics

typealias BusPosInfo = (location: CGFloat, number: String, congestion: BusCongestion, islower: Bool)

class BusRouteViewModel {

    private let usecase: BusRouteUsecase
    private var cancellables: Set<AnyCancellable> = []
    private let busRouteId: Int
    @Published var header: BusRouteDTO?
    @Published var bodys: [StationByRouteListDTO] = []
    @Published var buses: [BusPosInfo] = []

    init(usecase: BusRouteUsecase, busRouteId: Int) {
        self.usecase = usecase
        self.busRouteId = busRouteId
        self.bindingHeaderInfo()
        self.bindingBodysInfo()
        self.bindingBusesPosInfo()
    }

    private func bindingHeaderInfo() {
        self.usecase.$header
            .receive(on: BusRouteUsecase.queue)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { header in
                self.header = header
            })
            .store(in: &self.cancellables)
    }

    private func bindingBodysInfo() {
        self.usecase.$bodys
            .receive(on: BusRouteUsecase.queue)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { bodys in
                self.bodys = bodys
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

    private func busNumber(from: String) -> String {
        let startIndex = from.index(from.startIndex, offsetBy: 5)
        let endIndex = from.endIndex
        return String(from[startIndex..<endIndex])
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
