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
    weak var delegate: CoordinatorDelegate?
    var navigationPresenter: UINavigationController
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
        coordinator.delegate = self
        coordinator.navigationPresenter = self.navigationPresenter
        self.childCoordinators.append(coordinator)
        coordinator.start()
        
        self.navigationWindow.makeKeyAndVisible()
        self.movingStatusWindow.makeKeyAndVisible()
        
        self.close()
    }
}

// MARK: - Delegate : MovingStatusFoldUnfoldDelegate
extension AppCoordinator: MovingStatusFoldUnfoldDelegate {
    func fold() {
        self.movingStatusWindow.frame.origin = CGPoint(x: 0, y: self.navigationWindow.frame.height - MovingStatusView.bottomIndicatorHeight)
    }
    
    func unfold() {
        self.movingStatusWindow.frame.origin = CGPoint(x: 0, y: -MovingStatusView.bottomIndicatorHeight)
    }
}

// MARK: - Delegate : MovingStatusOpenCloseDelegate
extension AppCoordinator: MovingStatusOpenCloseDelegate {
    func open(busRouteId: Int, fromArsId: String, toArsId: String) {

        let usecase = MovingStatusUsecase(usecases: BBusAPIUsecases(on: MovingStatusUsecase.queue))
        let viewModel = MovingStatusViewModel(usecase: usecase, busRouteId: busRouteId, fromArsId: fromArsId, toArsId: toArsId)
        let viewController = MovingStatusViewController(viewModel: viewModel)
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
            self.movingStatusPresenter = nil
            self.movingStatusWindow.rootViewController = nil
        })
    }
}

// MARK: - Delegate : AlertCreateDelegate
extension AppCoordinator: AlertCreateDelegate {
    func presentAlert(controller: UIAlertController, completion: (() -> Void)? = nil) {
        self.navigationPresenter.present(controller, animated: false, completion: completion)
    }
}

// MARK: - Delegate : CoordinatorCreateDelegate
extension AppCoordinator: CoordinatorCreateDelegate {
    func pushSearch() {
        let coordinator = SearchCoordinator(presenter: self.navigationPresenter)
        coordinator.delegate = self
        coordinator.navigationPresenter = self.navigationPresenter
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }

    func pushBusRoute(busRouteId: Int) {
        let coordinator = BusRouteCoordinator(presenter: self.navigationPresenter)
        coordinator.delegate = self
        coordinator.navigationPresenter = self.navigationPresenter
        self.childCoordinators.append(coordinator)
        coordinator.start(busRouteId: busRouteId)
    }

    func pushAlarmSetting(stationId: Int, busRouteId: Int, stationOrd: Int, arsId: String, routeType: RouteType?, busName: String) {
        let coordinator = AlarmSettingCoordinator(presenter: self.navigationPresenter)
        coordinator.delegate = self
        coordinator.navigationPresenter = self.navigationPresenter
        self.childCoordinators.append(coordinator)
        coordinator.movingStatusDelegate = self
        coordinator.start(stationId: stationId,
                          busRouteId: busRouteId,
                          stationOrd: stationOrd,
                          arsId: arsId,
                          routeType: routeType,
                          busName: busName)
    }

    func pushStation(arsId: String) {
        let coordinator = StationCoordinator(presenter: self.navigationPresenter)
        coordinator.delegate = self
        coordinator.navigationPresenter = self.navigationPresenter
        self.childCoordinators.append(coordinator)
        coordinator.start(arsId: arsId)
    }
}

// MARK: - Delegate : CoordinatorFinishDelegate
extension AppCoordinator: CoordinatorFinishDelegate {
    func removeChildCoordinator(_ coordinator: Coordinator) {
        for (index, child) in self.childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
}

