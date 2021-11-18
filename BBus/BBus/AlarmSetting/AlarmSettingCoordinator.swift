//
//  AlarmSettingCoordinator.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/03.
//

import UIKit

class AlarmSettingCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    weak var movingStatusDelegate: MovingStatusOpenCloseDelegate?
    var navigationPresenter: UINavigationController

    init(presenter: UINavigationController) {
        self.navigationPresenter = presenter
    }

    func start(stationId: Int, busRouteId: Int, stationOrd: Int, arsId: String, routeType: RouteType?, busName: String) {
        let useCase = AlarmSettingUseCase(useCases: BBusAPIUsecases(on: AlarmSettingUseCase.queue))
        let viewModel = AlarmSettingViewModel(useCase: useCase,
                                              stationId: stationId,
                                              busRouteId: busRouteId,
                                              stationOrd: stationOrd,
                                              arsId: arsId,
                                              routeType: routeType,
                                              busName: busName)
        let viewController = AlarmSettingViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.navigationPresenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.navigationPresenter.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
    
    func openMovingStatus(busRouteId: Int, fromArsId: String, toArsId: String) {
        self.movingStatusDelegate?.open(busRouteId: busRouteId, fromArsId: fromArsId, toArsId: toArsId)
    }
    
    func closeMovingStatus() {
        self.movingStatusDelegate?.close()
    }
}
