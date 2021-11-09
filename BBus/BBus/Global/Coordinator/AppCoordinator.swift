//
//  AppCoordinator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

class AppCoordinator: NSObject, Coordinator {
    private let window: UIWindow
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(window: UIWindow) {
        self.window = window

        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        self.presenter = navigationController
        self.childCoordinators = []
    }

    func start() {
        self.window.rootViewController = self.presenter

        let coordinator = HomeCoordinator(presenter: self.presenter)
        coordinator.delegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()

        self.window.makeKeyAndVisible()
    }
}
