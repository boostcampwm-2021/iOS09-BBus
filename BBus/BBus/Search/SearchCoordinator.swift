//
//  SearchBusCoordinator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

class SearchCoordinator: BusRoutePushable, StationPushable {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let viewController = SearchViewController()
        viewController.coordinator = self
        self.presenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.presenter.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
}
