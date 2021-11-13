//
//  BusRouteViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine
import CoreGraphics

class BusRouteViewModel {

    private let usecase: BusRouteUsecase
    private var cancellables: Set<AnyCancellable> = []
    @Published var header: BusRouteDTO?
    @Published var bodys: [StationByRouteListDTO] = []
    @Published var buses: [BusPosByRtidDTO] = []

    init(usecase: BusRouteUsecase) {
        self.usecase = usecase
        self.bindingHeaderInfo()
        self.bindingBodysInfo()
        self.bindingBusesPosInfo()
        self.usecase.searchHeader()
        self.usecase.fetchRouteList()
        self.usecase.fetchBusPosList()
        print(self.convertBusPos(order: 3, sect: "0.079", fullSect: "0.236"))
        print(self.busNumber(from: "서울74사6161"))
    }

    private func bindingHeaderInfo() {
        self.usecase.$header
            .receive(on: BusRouteUsecase.thread)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { header in
                self.header = header
            })
            .store(in: &cancellables)
    }

    private func bindingBodysInfo() {
        self.usecase.$bodys
            .receive(on: BusRouteUsecase.thread)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { bodys in
                self.bodys = bodys
            })
            .store(in: &cancellables)
    }

    private func bindingBusesPosInfo() {
        self.usecase.$buses
            .receive(on: BusRouteUsecase.thread)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { buses in
                self.buses = buses
            })
            .store(in: &cancellables)
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
}
// 1. 버스위치 변환
// 2. 버스번호 추출
// 3. 저상 변환
// 4. 여유 변환
