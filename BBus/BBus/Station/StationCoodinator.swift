//
//  StationCoodinator.swift
//  BBus
//
//  Created by 이지수 on 2021/11/03.
//

import UIKit

class StationCoordinator: BusRoutePushable, AlarmSettingPushable {
    var delegate: CoordinatorDelegate?
    var navigationPresenter: UINavigationController?
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController?) {
        self.navigationPresenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let viewController = StationViewController()
        viewController.coordinator = self
        self.navigationPresenter?.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.navigationPresenter?.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
}
