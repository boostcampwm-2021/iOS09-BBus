//
//  SearchBusCoordinator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

class SearchBusCoordinator: NSObject, Coordinator, BusRoutePushable, StationPushable {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let viewController = SearchBusViewController()
        viewController.coordinator = self
        presenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.coordinatorDidFinish()
    }
}
