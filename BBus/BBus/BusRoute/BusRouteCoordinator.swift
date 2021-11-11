//
//  BusCoordinator.swift
//  BBus
//
//  Created by 최수정 on 2021/11/03.
//

import UIKit

class BusRouteCoordinator: StationPushable {
    var navigationPresenter: UINavigationController
    var delegate: CoordinatorDelegate?

    init(presenter: UINavigationController) {
        self.navigationPresenter = presenter
    }

    func start(busRouteId: Int) {
        // TODO: inject busRouteId
        print(busRouteId)
        let viewController = BusRouteViewController()
        viewController.coordinator = self
        self.navigationPresenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.navigationPresenter.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
}
