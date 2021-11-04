//
//  StationPushable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/03.
//

import Foundation

protocol StationPushable: Coordinator {
    func pushToStation()
}

extension StationPushable {
    func pushToStation() {
        let coordinator = StationCoordinator(presenter: self.presenter)
        coordinator.delegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
