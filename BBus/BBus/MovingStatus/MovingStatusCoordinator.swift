//
//  MovingStatusCoordinator.swift
//  BBus
//
//  Created by 최수정 on 2021/11/04.
//

import UIKit

class MovingStatusCoordinator: MovingStatusPushable {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let viewController = MovingStatusViewController()
        viewController.coordinator = self
        presenter.pushViewController(viewController, animated: true)
    }
}
