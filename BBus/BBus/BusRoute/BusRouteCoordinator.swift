//
//  BusCoordinator.swift
//  BBus
//
//  Created by 최수정 on 2021/11/03.
//

import UIKit

class BusRouteCoordinator: NSObject, Coordinator, StationPushable {
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
