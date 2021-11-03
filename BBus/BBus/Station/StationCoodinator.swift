//
//  StationCoodinator.swift
//  BBus
//
//  Created by 이지수 on 2021/11/03.
//

import UIKit

class StationCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let viewController = StationViewController()
        viewController.coordinator = self
        presenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.coordinatorDidFinish()
    }
}