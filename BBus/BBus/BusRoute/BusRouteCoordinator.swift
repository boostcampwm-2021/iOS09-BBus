//
//  BusCoordinator.swift
//  BBus
//
//  Created by 최수정 on 2021/11/03.
//

import UIKit

class BusRouteCoordinator: StationPushable {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationPresenter: UINavigationController?
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController?) {
        self.navigationPresenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let viewController = BusRouteViewController()
        viewController.coordinator = self
        self.navigationPresenter?.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.navigationPresenter?.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
}
