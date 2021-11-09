//
//  HomeCoornicator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

class HomeCoordinator: SearchBusPushable, BusRoutePushable, AlarmSettingPushable, StationPushable {
    var delegate: CoordinatorDelegate?
    var navigationPresenter: UINavigationController? 
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController?) {
        self.navigationPresenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let useCase = HomeUseCase()
        let viewModel = HomeViewModel(useCase: useCase)
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationPresenter?.pushViewController(viewController, animated: false) // present
    }
}

