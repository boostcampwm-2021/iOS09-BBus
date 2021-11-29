//
//  BusRouteCoordinator.swift
//  BBus
//
//  Created by 최수정 on 2021/11/03.
//

import UIKit

final class BusRouteCoordinator: StationPushable {
    var navigationPresenter: UINavigationController
    weak var delegate: CoordinatorDelegate?

    init(presenter: UINavigationController) {
        self.navigationPresenter = presenter
    }

    func start(busRouteId: Int) {
        let apiUseCases = BBusAPIUseCases(networkService: NetworkService(),
                                          persistenceStorage: PersistenceStorage(),
                                          requestFactory: RequestFactory())
        let usecase = BusRouteAPIUsecase(usecases: apiUseCases)
        let viewModel = BusRouteViewModel(usecase: usecase, busRouteId: busRouteId)
        let viewController = BusRouteViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.navigationPresenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.navigationPresenter.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
}
