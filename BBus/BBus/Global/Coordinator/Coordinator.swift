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

protocol CoordinatorCreateDelegate {
    func pushSearch()
    func pushBusRoute()
    func pushAlarmSetting()
    func pushStation()
}

typealias CoordinatorDelegate = (CoordinatorFinishDelegate & CoordinatorCreateDelegate)

protocol Coordinator: AnyObject {
    var navigationPresenter: UINavigationController { get set }
    var delegate: CoordinatorDelegate? { get set }
    func start()
}

extension Coordinator {
    func start() { }

    func coordinatorDidFinish() {
        self.delegate?.removeChildCoordinator(self)
    }
}
