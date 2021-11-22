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
    func pushBusRoute(busRouteId: Int)
    func pushAlarmSetting(stationId: Int, busRouteId: Int, stationOrd: Int, arsId: String, routeType: RouteType?, busName: String)
    func pushStation(arsId: String)
}

protocol AlertCreateDelegate {
    func presentAlertToNavigation(controller: UIAlertController, completion: (() -> Void)?)
    func presentAlertToMovingStatus(controller: UIAlertController, completion: (() -> Void)?)
}

typealias CoordinatorDelegate = (CoordinatorFinishDelegate & CoordinatorCreateDelegate & AlertCreateDelegate)

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
