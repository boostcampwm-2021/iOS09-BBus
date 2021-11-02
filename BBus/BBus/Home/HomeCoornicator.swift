//
//  HomeCoornicator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

class HomeCoordinator: SearchBusPushable {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let useCase = HomeUseCase()
        let viewModel = HomeViewModel(useCase: useCase)
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.coordinator = self
        presenter.pushViewController(viewController, animated: false) // present
    }
}

