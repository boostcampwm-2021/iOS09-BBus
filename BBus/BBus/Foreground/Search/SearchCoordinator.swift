//
//  SearchBusCoordinator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

final class SearchCoordinator: BusRoutePushable, StationPushable {
    weak var delegate: CoordinatorDelegate?
    var navigationPresenter: UINavigationController

    init(presenter: UINavigationController) {
        self.navigationPresenter = presenter
    }

    func start() {
        let usecase = SearchUseCase(usecases: BBusAPIUsecases(on: SearchUseCase.queue))
        let viewModel = SearchViewModel(usecase: usecase)
        let viewController = SearchViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.navigationPresenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.navigationPresenter.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
}