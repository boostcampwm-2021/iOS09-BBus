//
//  StationCoodinator.swift
//  BBus
//
//  Created by 이지수 on 2021/11/03.
//

import UIKit

class StationCoordinator: BusRoutePushable, AlarmSettingPushable {
    var delegate: CoordinatorDelegate?
    var navigationPresenter: UINavigationController

    init(presenter: UINavigationController) {
        self.navigationPresenter = presenter
    }

    func start(arsId: String) {
        let usecase = StationUsecase(usecases: BBusAPIUsecases(on: StationUsecase.thread))
        let viewModel = StationViewModel(usecase: usecase, arsId: arsId)
        let viewController = StationViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.navigationPresenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.navigationPresenter.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
}
