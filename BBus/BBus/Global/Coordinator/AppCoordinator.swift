//
//  AppCoordinator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

final class AppCoordinator: NSObject, Coordinator {
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
        
        UIView.animate(withDuration: 0.3, animations: {
            self.fold()
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.movingStatusWindow.isHidden = true
            self.movingStatusPresenter = nil
            self.movingStatusWindow.rootViewController = nil
        })
    }
}

// MARK: - Delegate : MovingStatusFoldUnfoldDelegate
extension AppCoordinator: MovingStatusFoldUnfoldDelegate {
    func fold() {
        self.movingStatusWindow.frame.origin = CGPoint(x: 0, y: self.navigationWindow.frame.height)
    }
    
    func unfold() {
        self.movingStatusWindow.frame.origin = CGPoint(x: 0, y: -MovingStatusView.bottomIndicatorHeight)
    }
}

// MARK: - Delegate : MovingStatusOpenCloseDelegate
extension AppCoordinator: MovingStatusOpenCloseDelegate {
    func open(busRouteId: Int, fromArsId: String, toArsId: String) {
        if self.movingStatusWindow.isHidden {
            self.navigationWindow.frame.size = CGSize(width: self.navigationWindow.frame.width, height: self.navigationWindow.frame.height - MovingStatusView.bottomIndicatorHeight)
        }
        
        let usecase = MovingStatusUsecase(usecases: BBusAPIUsecases())
        let viewModel = MovingStatusViewModel(usecase: usecase, busRouteId: busRouteId, fromArsId: fromArsId, toArsId: toArsId)
        let viewController = MovingStatusViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.movingStatusPresenter = viewController
        self.movingStatusWindow.rootViewController = self.movingStatusPresenter
        self.movingStatusWindow.isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.unfold()
        }
    }

    func reset(busRouteId: Int, fromArsId: String, toArsId: String) {
        let usecase = MovingStatusUsecase(usecases: BBusAPIUsecases())
        let viewModel = MovingStatusViewModel(usecase: usecase, busRouteId: busRouteId, fromArsId: fromArsId, toArsId: toArsId)
        let viewController = MovingStatusViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.movingStatusPresenter = viewController
        self.movingStatusWindow.rootViewController = self.movingStatusPresenter
        self.movingStatusWindow.isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.unfold()
        }
    }
    
    func close() {
        self.navigationWindow.frame.size = CGSize(width: self.navigationWindow.frame.width, height: self.navigationWindow.frame.height + MovingStatusView.bottomIndicatorHeight)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.fold()
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.movingStatusWindow.isHidden = true
            self.movingStatusPresenter = nil
            self.movingStatusWindow.rootViewController = nil
        })
        GetOffAlarmController.shared.stop()
    }
}

// MARK: - Delegate : AlertCreateToNavigation
extension AppCoordinator: AlertCreateToNavigationDelegate {
    func presentAlertToNavigation(controller: UIAlertController, completion: (() -> Void)? = nil) {
        self.navigationPresenter.present(controller, animated: false, completion: completion)
    }
}

// MARK: - Delegate : AlertCreateToMovingStatus
extension AppCoordinator: AlertCreateToMovingStatusDelegate {
    func presentAlertToMovingStatus(controller: UIAlertController, completion: (() -> Void)? = nil) {
        self.movingStatusPresenter?.present(controller, animated: false, completion: completion)
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

