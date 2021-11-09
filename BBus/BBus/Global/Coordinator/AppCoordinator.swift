//
//  AppCoordinator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

class AppCoordinator: NSObject, Coordinator {
    private let navigationWindow: UIWindow
    private let movingStatusWindow: UIWindow
    var delegate: CoordinatorDelegate?
    var navigationPresenter: UINavigationController?
    var movingStatusPresenter: UIViewController?
    var childCoordinators: [Coordinator]

    init(navigationWindow: UIWindow, movingStatusWindow: UIWindow) {
        self.navigationWindow = navigationWindow
        self.movingStatusWindow = movingStatusWindow

        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        self.navigationPresenter = navigationController
        self.childCoordinators = []
    }

    func start() {
        self.navigationWindow.rootViewController = self.navigationPresenter

        let coordinator = HomeCoordinator(presenter: self.navigationPresenter)
        coordinator.finishDelegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
        
        self.navigationWindow.makeKeyAndVisible()
        self.movingStatusWindow.makeKeyAndVisible()
        
        self.close()
    }
}

extension AppCoordinator: MovingStatusFoldUnfoldDelegate {
    func fold() {
        self.movingStatusWindow.frame.origin = CGPoint(x: 0, y: self.navigationWindow.frame.height - MovingStatusView.bottomIndicatorHeight)
    }
    
    func unfold() {
        self.movingStatusWindow.frame.origin = CGPoint(x: 0, y: -MovingStatusView.bottomIndicatorHeight)
    }
}

extension AppCoordinator: MovingStatusOpenCloseDelegate {
    func open() {
        let viewController = MovingStatusViewController()
        viewController.coordinator = self
        self.movingStatusPresenter = viewController
        self.movingStatusWindow.rootViewController = self.movingStatusPresenter
        
        self.movingStatusWindow.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.unfold()
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.fold()
        }, completion: { _ in
            self.movingStatusWindow.isHidden = true
            self.navigationPresenter = nil
            self.movingStatusWindow.rootViewController = nil
        })
    }
}
