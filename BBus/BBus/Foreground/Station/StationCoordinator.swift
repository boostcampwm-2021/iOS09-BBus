//
//  StationCoordinator.swift
//  BBus
//
//  Created by 이지수 on 2021/11/03.
//

import UIKit

final class StationCoordinator: BusRoutePushable, AlarmSettingPushable {
    weak var delegate: CoordinatorDelegate?
    var navigationPresenter: UINavigationController

    init(presenter: UINavigationController) {
        self.navigationPresenter = presenter
    }

    func start(arsId: String) {
        let apiUseCases = BBusAPIUseCases(networkService: NetworkService(),
                                          persistenceStorage: PersistenceStorage(),
                                          tokenManageType: TokenManager.self,
                                          requestFactory: RequestFactory.self)
        let apiUseCase = StationAPIUseCase(useCases: apiUseCases)
        let calculateUseCase = StationCalculateUseCase()
        let viewModel = StationViewModel(apiUseCase: apiUseCase,
                                         calculateUseCase: calculateUseCase,
                                         arsId: arsId)
        let viewController = StationViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.navigationPresenter.pushViewController(viewController, animated: true)
    }

    func terminate() {
        self.navigationPresenter.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
}
