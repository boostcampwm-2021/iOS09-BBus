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
class MovingStatusViewModel {

    private let usecase: MovingStatusUsecase
    private var cancellables: Set<AnyCancellable> = []
    private let busRouteId: Int
    private let fromArsId: String
    private let toArsId: String
    @Published var busInfo: BusInfo?

    init(usecase: MovingStatusUsecase, busRouteId: Int, fromArsId: String, toArsId: String) {
        self.usecase = usecase
        self.busRouteId = busRouteId
        self.fromArsId = fromArsId
        self.toArsId = toArsId
        self.bindingHeaderInfo()
    }

    private func bindingHeaderInfo() {
        self.usecase.$header
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { header in
                self.convertBusInfo(header: header)
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

    func fetch() {
        self.usecase.searchHeader(busRouteId: self.busRouteId)
    }
}
