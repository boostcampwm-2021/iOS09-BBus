//
//  HomeCoordinator.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

final class HomeCoordinator: SearchPushable, BusRoutePushable, AlarmSettingPushable, StationPushable {
    weak var delegate: CoordinatorDelegate?
    var navigationPresenter: UINavigationController

    init(presenter: UINavigationController) {
        self.navigationPresenter = presenter
    }

    func start(statusBarHeight: CGFloat?) {
        let apiUseCases = BBusAPIUseCases(networkService: NetworkService(),
                                          persistenceStorage: PersistenceStorage(),
                                          tokenManageType: TokenManager.self,
                                          requestFactory: RequestFactory())
        let apiUseCase = HomeAPIUseCase(useCases: apiUseCases)
        let calculateUseCase = HomeCalculateUseCase()
        let viewModel = HomeViewModel(apiUseCase: apiUseCase, calculateUseCase: calculateUseCase)
        let viewController = HomeViewController(viewModel: viewModel, statusBarHegiht: statusBarHeight)
        viewController.coordinator = self

        navigationPresenter.pushViewController(viewController, animated: false) // present
    }
}
