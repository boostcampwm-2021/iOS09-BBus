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
        movingStatusViewController.coordinator = self
        sceneDelegate.movingStatusViewController = movingStatusViewController

        movingStatusViewController.view.frame.size = CGSize(width: window.frame.width, height: window.frame.height + MovingStatusView.bottomIndicatorHeight)
        movingStatusViewController.view.frame.origin = CGPoint(x: 0, y: window.frame.height)
        window.addSubview(movingStatusViewController.view)
    }
    
    func terminate() {
        guard let window = UIApplication.shared.windows.first,
              let sceneDelegate = window.windowScene?.delegate as? SceneDelegate,
              let movingStatusViewController = sceneDelegate.movingStatusViewController else { return }
        UIView.animate(withDuration: 0.3) {
            movingStatusViewController.view.frame.origin = CGPoint(x: 0, y: movingStatusViewController.view.frame.height-MovingStatusView.bottomIndicatorHeight*3)
        } completion: { _ in
            sceneDelegate.movingStatusViewController?.view.removeFromSuperview()
            sceneDelegate.movingStatusViewController = nil
        }
    }
}
