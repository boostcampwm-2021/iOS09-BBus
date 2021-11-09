//
//  MovingStatusPushable.swift
//  BBus
//
//  Created by 최수정 on 2021/11/04.
//

import Foundation

protocol MovingStatusPushable: Coordinator {
    func pushToMovingStatus()
}

extension MovingStatusPushable {
    func pushToMovingStatus() {
        let coordinator = MovingStatusCoordinator(presenter: self.presenter)
        coordinator.delegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
