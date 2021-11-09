//
//  Coordinator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish()
    func removeChildCoordinator(_ coordinator: Coordinator)
}

protocol Coordinator: CoordinatorFinishDelegate {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationPresenter: UINavigationController? { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func start() { }

    func coordinatorDidFinish() {
        self.finishDelegate?.removeChildCoordinator(self)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        for (index, child) in self.childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
}
