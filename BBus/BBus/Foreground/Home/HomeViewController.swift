//
//  HomeViewController.swift
//  BBus
//
//  Created by Kang Minsang on 2021/10/26.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    private var lastContentOffset: CGFloat = 0
    private let refreshButtonWidth: CGFloat = 50

    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeViewModel?

    private lazy var homeView = HomeView()
    lazy var refreshButton: ThrottleButton = {
        let button = ThrottleButton()
        button.setImage(BBusImage.refresh, for: .normal)
        button.layer.cornerRadius = self.refreshButtonWidth / 2
        button.tintColor = BBusColor.white
        button.addTouchUpEventWithThrottle(delay: ThrottleButton.refreshInterval) { [weak self] in
            self?.viewModel?.reloadFavoriteData()
        }
        return button
    }()

    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.configureColor()
        self.configureLayout()
        self.binding()
        self.homeView.configureLayout()
        self.homeView.configureDelegate(self)
        
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height

        let statusbarView = UIView()
        statusbarView.backgroundColor = BBusColor.white //컬러 설정 부분
        
        self.view.addSubviews(statusbarView)
        statusbarView.heightAnchor
            .constraint(equalToConstant: statusBarHeight).isActive = true
        statusbarView.widthAnchor
            .constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        statusbarView.topAnchor
            .constraint(equalTo: self.view.topAnchor).isActive = true
        statusbarView.centerXAnchor
            .constraint(equalTo: self.view.centerXAnchor).isActive = true

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.reloadFavoriteData()
        self.viewModel?.configureObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel?.cancelObserver()
    }

    // MARK: - Configuration
    private func configureLayout() {
        self.view.addSubviews(self.homeView, self.refreshButton)

        NSLayoutConstraint.activate([
            self.homeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.homeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.homeView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.homeView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])

        self.refreshButton.backgroundColor = BBusColor.darkGray
        let refreshTrailingBottomInterval: CGFloat = -16
        NSLayoutConstraint.activate([
            self.refreshButton.widthAnchor.constraint(equalToConstant: self.refreshButtonWidth),
            self.refreshButton.heightAnchor.constraint(equalTo: self.refreshButton.widthAnchor),
            self.refreshButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: refreshTrailingBottomInterval),
            self.refreshButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: refreshTrailingBottomInterval)
        ])
    }
    
    private func configureColor() {
        self.view.backgroundColor = BBusColor.white
    }

    private func binding() {
        self.bindFavoriteList()
        self.bindNetworkError()
    }

    private func bindFavoriteList() {

        self.viewModel?.$homeFavoriteList
            .compactMap { $0 }
            .filter { !$0.changedByTimer }
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] response in
                let isFavoriteEmpty = response.count() == 0
                self?.homeView.emptyNoticeActivate(by: isFavoriteEmpty)
                self?.homeView.reload()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindNetworkError() {
        self.viewModel?.useCase.$networkError
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                guard let _ = error else { return }
                self?.networkAlert()
            })
            .store(in: &self.cancellables)
    }
    
    private func networkAlert() {
        let controller = UIAlertController(title: "네트워크 장애", message: "네트워크 장애가 발생하여 앱이 정상적으로 동작되지 않습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        controller.addAction(action)
        self.coordinator?.delegate?.presentAlertToNavigation(controller: controller, completion: nil)
    }
}

// MARK: - Delegate : UICollectionView
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let busRouteIdString = self.viewModel?.homeFavoriteList?[indexPath.section]?[indexPath.item]?.favoriteItem.busRouteId,
              let busRouteId = Int(busRouteIdString) else { return }

        self.coordinator?.pushToBusRoute(busRouteId: busRouteId)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minimumScrollOffset = HomeNavigationView.height - 20

        guard scrollView.contentOffset.y > minimumScrollOffset else { return }
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            self.homeView.configureNavigationViewVisable(true)
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            self.homeView.configureNavigationViewVisable(false)
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
}

// MARK: - DataSource : UICollectionView
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel?.homeFavoriteList?.count() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.homeFavoriteList?[section]?.count() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath)
                as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
      
        cell.configureDelegate(self)
        
        self.viewModel?.$homeFavoriteList
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { $0.changedByTimer }
            .sink(receiveValue: { [weak self, weak cell] homeFavoriteList in
                guard let model = homeFavoriteList[indexPath.section]?[indexPath.item],
                      let busName = self?.viewModel?.busName(by: model.favoriteItem.busRouteId),
                      let busType = self?.viewModel?.busType(by: busName) else { return }
                let busArrivalInfo = model.arriveInfo
                cell?.configure(busNumber: busName,
                               routeType: busType,
                               firstBusTime: busArrivalInfo?.firstTime.toString(),
                               firstBusRelativePosition: busArrivalInfo?.firstRemainStation,
                               firstBusCongestion: busArrivalInfo?.firstBusCongestion?.toString(),
                               secondBusTime: busArrivalInfo?.secondTime.toString(),
                               secondBusRelativePosition: busArrivalInfo?.secondRemainStation,
                               secondBusCongestion: busArrivalInfo?.secondBusCongestion?.toString())
            })
            .store(in: &cell.cancellables)
        guard let model = self.viewModel?.homeFavoriteList?[indexPath.section]?[indexPath.item],
              let cellOrd = Int(model.favoriteItem.ord),
              let cellBusRouteId = Int(model.favoriteItem.busRouteId),
              let cellStId = Int(model.favoriteItem.stId) else { return cell }
        let cellArsId = model.favoriteItem.arsId
        let getOnAlarmViewModel = GetOnAlarmController.shared.viewModel
        let getOffAlarmViewModel = GetOffAlarmController.shared.viewModel
        if (getOnAlarmViewModel?.getOnAlarmStatus.targetOrd == cellOrd &&
            getOnAlarmViewModel?.getOnAlarmStatus.busRouteId == cellBusRouteId &&
            getOnAlarmViewModel?.getOnAlarmStatus.stationId == cellStId) || (
                getOffAlarmViewModel?.getOffAlarmStatus.arsId == cellArsId &&
                getOffAlarmViewModel?.getOffAlarmStatus.busRouteId == cellBusRouteId
            ) {
            cell.configure(alarmButtonActive: true)
        }
        else {
            cell.configure(alarmButtonActive: false)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter :
            if let footer = footer(with: collectionView, indexPath: indexPath) {
                return footer
            }
        case UICollectionView.elementKindSectionHeader :
            if let header = header(with: collectionView, indexPath: indexPath) {
                return header
            }
        default :
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    private func footer(with collectionView: UICollectionView, indexPath: IndexPath) -> SourceFooterView? {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SourceFooterView.identifier, for: indexPath) as? SourceFooterView else { return nil }
        if let maxSize = self.footerSize(with: collectionView) {
            footer.frame.size = maxSize
        }
        return footer
    }
    
    private func footerSize(with collectionView: UICollectionView) -> CGSize? {
        guard collectionView.contentSize.height < collectionView.frame.height else { return nil }
        let gap = collectionView.frame.height - collectionView.contentSize.height
        return CGSize(width: self.view.frame.width, height: SourceFooterView.height + gap)
    }
    
    private func header(with collectionView: UICollectionView, indexPath: IndexPath) -> FavoriteCollectionHeaderView? {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteCollectionHeaderView.identifier, for: indexPath) as? FavoriteCollectionHeaderView else { return nil }
        
        guard let stationId = self.viewModel?.homeFavoriteList?[indexPath.section]?.stationId,
              let stationName = self.viewModel?.stationName(by: stationId),
              let arsId = self.viewModel?.homeFavoriteList?[indexPath.section]?.arsId else { return header }

        header.configureDelegate(self)
        header.configure(title: stationName, arsId: arsId)
        
        return header
    }
}

// MARK: - DelegateFlowLayout : UICollectionView
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: FavoriteCollectionViewCell.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.view.frame.width, height: FavoriteCollectionHeaderView.height + HomeNavigationView.height)
        }
        else {
            return CGSize(width: self.view.frame.width, height: FavoriteCollectionHeaderView.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard section == (self.viewModel?.homeFavoriteList?.count() ?? 1) - 1 else { return CGSize.zero }
        return CGSize(width: self.view.frame.width, height: SourceFooterView.height)
    }
}

// MARK: - HomeSearchButtonDelegate : UICollectionView
extension HomeViewController: HomeSearchButtonDelegate {
    func shouldGoToSearchScene() {
        self.coordinator?.pushToSearch()
    }
}

// MARK: - AlarmButtonDelegate : UICollectionView
extension HomeViewController: AlarmButtonDelegate {
    func shouldGoToAlarmSettingScene(at cell: UICollectionViewCell) {
      
        guard let indexPath = self.homeView.indexPath(for: cell),
              let model = self.viewModel?.homeFavoriteList?[indexPath.section]?[indexPath.item],
              let stationId = Int(model.favoriteItem.stId),
              let busRouteId = Int(model.favoriteItem.busRouteId),
              let ord = Int(model.favoriteItem.ord),
              let busName = self.viewModel?.busName(by: "\(busRouteId)"),
              let routeType = self.viewModel?.busType(by: busName) else { return }
        let arsId = model.favoriteItem.arsId

        self.coordinator?.pushToAlarmSetting(stationId: stationId,
                                             busRouteId: busRouteId,
                                             stationOrd: ord,
                                             arsId: arsId,
                                             routeType: routeType,
                                             busName: busName)
    }
}

// MARK: - FavoriteHeaderViewDelegate : UICollectionView
extension HomeViewController: FavoriteHeaderViewDelegate {
    func shouldGoToStationScene(headerView: UICollectionReusableView) {
        guard let section = self.homeView.getSectionByHeaderView(header: headerView),
              let arsId = self.viewModel?.homeFavoriteList?[section]?.arsId else { return }

        self.coordinator?.pushToStation(arsId: arsId)
    }
}
