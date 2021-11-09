//
//  Coordinator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

protocol CoordinatorFinishDelegate {
    func coordinatorDidFinish()
    func removeChildCoordinator(_ coordinator: Coordinator)
}

protocol Coordinator: AnyObject, CoordinatorFinishDelegate {
    var delegate: CoordinatorFinishDelegate? { get set }
    var presenter: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}


extension Coordinator {
    func start() { }

    func coordinatorDidFinish() {
        self.delegate?.removeChildCoordinator(self)
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
