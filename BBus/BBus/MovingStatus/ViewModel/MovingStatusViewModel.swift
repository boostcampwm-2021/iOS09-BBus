//
//  MovingStatusViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine
import CoreGraphics

class MovingStatusViewModel {

    private let usecase: MovingStatusUsecase
    private var cancellables: Set<AnyCancellable> = []
    private let busRouteId: Int
    private let fromArsId: String
    private let toArsId: String
    @Published var busName: String?

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
            .sink { error in
                print(error)
            } receiveValue: { header in
                self.busName = header?.busRouteName
            }
            .store(in: &self.cancellables)
    }

    func fetch() {
        self.usecase.searchHeader(busRouteId: self.busRouteId)
    }
}
