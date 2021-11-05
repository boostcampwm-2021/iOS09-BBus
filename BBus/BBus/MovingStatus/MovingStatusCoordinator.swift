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
        guard let window = UIApplication.shared.windows.first,
              let sceneDelegate = window.windowScene?.delegate as? SceneDelegate else { return }

        let movingStatusViewController = MovingStatusViewController()
        sceneDelegate.movingStatusViewController = movingStatusViewController

        movingStatusViewController.view.frame = window.frame
//        view.frame.origin = CGPoint(x: 0, y: 830)
        window.addSubview(movingStatusViewController.view)
    }
}
