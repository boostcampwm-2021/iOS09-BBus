//
//  BusRoutePushable.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/03.
//

import Foundation

protocol BusRoutePushable: Coordinator {
    func pushToBusRoute()
}

extension BusRoutePushable {
    func pushToBusRoute() {
        let coordinator = BusRouteCoordinator(presenter: self.presenter)
        coordinator.delegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
