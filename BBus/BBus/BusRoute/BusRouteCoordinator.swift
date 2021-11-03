//
//  BusCoordinator.swift
//  BBus
//
//  Created by 최수정 on 2021/11/03.
//

import UIKit

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

class BusRouteCoordinator: Coordinator, StationPushable {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let viewController = BusRouteViewController()
        viewController.coordinator = self
        presenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.coordinatorDidFinish()
    }
}

class StationCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let viewController = StationViewController()
        presenter.pushViewController(viewController, animated: true)
    }
}
