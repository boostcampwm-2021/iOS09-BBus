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
typealias StationInfo = (speed: Int, afterSpeed: Int?, count: Int, title: String, fullDistance: Int)

final class MovingStatusViewModel {

    private let usecase: MovingStatusUsecase
    private var cancellables: Set<AnyCancellable>
    private let busRouteId: Int
    private let fromArsId: String
    private let toArsId: String
    @Published var busInfo: BusInfo?
    @Published var stationsInfo: [StationInfo] = []

    init(usecase: MovingStatusUsecase, busRouteId: Int, fromArsId: String, toArsId: String) {
        self.usecase = usecase
        self.busRouteId = busRouteId
        self.fromArsId = fromArsId
        self.toArsId = toArsId
        self.cancellables = []
        self.bindingHeaderInfo()
        self.bindingStationsInfo()
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

    private func convertBusInfo(header: BusRouteDTO?) {
        guard let header = header else { return }

        let busInfo: BusInfo
        busInfo.busName = header.busRouteName
        busInfo.type = header.routeType

        self.busInfo = busInfo
    }

    private func convertBusStations(with stations: [StationByRouteListDTO]) {
        // fromArsId - toArsId 로 줄여야 한다
        var startIndex: Int? = stations.firstIndex(where: { $0.arsId == self.fromArsId })
        var endIndex: Int? = stations.firstIndex(where: { $0.arsId == self.toArsId })
        print(startIndex, endIndex)

    }

    func fetch() {
        self.usecase.searchHeader(busRouteId: self.busRouteId)
        self.usecase.fetchRouteList(busRouteId: self.busRouteId)
    }
}
