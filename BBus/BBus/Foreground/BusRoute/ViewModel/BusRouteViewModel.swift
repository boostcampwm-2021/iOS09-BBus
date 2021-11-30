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

final class BusRouteViewModel {

    let useCase: BusRouteAPIUseCase
    private var cancellables: Set<AnyCancellable>
    private let busRouteId: Int
    @Published var header: BusRouteDTO?
    @Published var bodys: [BusStationInfo]
    @Published var buses: [BusPosInfo]
    @Published private(set) var stopLoader: Bool = false
    @Published private(set) var networkError: Error?

    init(useCase: BusRouteAPIUseCase, busRouteId: Int) {
        self.useCase = useCase
        self.busRouteId = busRouteId
        self.cancellables = []
        self.bodys = []
        self.buses = []
        self.bindLoader()
        self.bindHeaderInfo()
        self.bindBodysInfo()
        self.bindBusesPosInfo()
    }

    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBusPos), name: .thirtySecondPassed, object: nil)
    }

    func cancelObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    private func bindHeaderInfo() {
        self.useCase.searchHeader(busRouteId: self.busRouteId)
            .receive(on: DispatchQueue.global())
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$header)
    }

    private func bindBodysInfo() {
        self.useCase.fetchRouteList(busRouteId: self.busRouteId)
            .receive(on: DispatchQueue.global())
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .sink(receiveValue: { [weak self] bodys in
                self?.convertBusStationInfo(with: bodys)
            })
            .store(in: &self.cancellables)
    }

    private func bindBusesPosInfo() {
        self.useCase.fetchBusPosList(busRouteId: self.busRouteId)
            .receive(on: DispatchQueue.global())
            .catchError({ [weak self] error in
                self?.networkError = error
            })
            .sink(receiveValue: { [weak self] buses in
                self?.convertBusPosInfo(with: buses)
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
        buses.forEach { [weak self] bus in
            guard let self = self else { return }

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

    @objc func refreshBusPos() {
        self.bindBusesPosInfo()
    }

    func isStopLoader() -> Bool {
        return self.header != nil && !self.bodys.isEmpty && !self.buses.isEmpty
    }

    private func bindLoader() {
        self.$header.zip(self.$bodys)
            .receive(on: DispatchQueue.global())
            .dropFirst()
            .sink(receiveValue: { result in
                self.stopLoader = true
            })
            .store(in: &self.cancellables)
    }
}
