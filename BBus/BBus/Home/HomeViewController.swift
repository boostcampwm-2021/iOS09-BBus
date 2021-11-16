//
//  ViewController.swift
//  BBus
//
//  Created by Kang Minsang on 2021/10/26.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeViewModel?
    private lazy var homeView = HomeView()
    private var lastContentOffset: CGFloat = 0
    private var cancellable: AnyCancellable?

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
        self.view.addSubview(statusbarView)
        statusbarView.translatesAutoresizingMaskIntoConstraints = false
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
    }

    // MARK: - Configuration
    private func configureLayout() {
        self.view.addSubview(self.homeView)
        self.homeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.homeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.homeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.homeView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.homeView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureColor() {
        self.view.backgroundColor = BBusColor.white
    }

    private func binding() {
        self.bindingFavoriteList()
    }

    private func bindingFavoriteList() {
        self.cancellable = self.viewModel?.$homeFavoriteList
            .receive(on: HomeUseCase.thread)
            .sink(receiveValue: { response in
                dump(response)
                DispatchQueue.main.async {
                    self.homeView.reload()
                }
            })
    }
}

// MARK: - Delegate : UICollectionView
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let busRouteIdString = self.viewModel?.homeFavoriteList?[indexPath.section]?[indexPath.item]?.0.busRouteId,
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
        guard let model = self.viewModel?.homeFavoriteList?[indexPath.section]?[indexPath.item],
              let busName = self.viewModel?.busName(by: model.0.busRouteId)  else { return cell }
          let firstRemainStation = model.1?.firstRemainStation
          let secondRemainStation = model.1?.secondRemainStation
        cell.configureDelegate(self)
        cell.configure(busNumber: busName,
                       firstBusTime: model.1?.firstTime.toString(),
                          firstBusRelativePosition: firstRemainStation,
                          firstBusCongestion: "여유",
                       secondBusTime: model.1?.secondTime.toString(),
                          secondBusRelativePosition: secondRemainStation,
                          secondBusCongsetion: "여유")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoriteCollectionHeaderView.identifier, for: indexPath) as? FavoriteCollectionHeaderView else { return UICollectionReusableView() }
        guard let stationId = self.viewModel?.homeFavoriteList?[indexPath.section]?.stationId,
              let stationName = self.viewModel?.stationName(by: stationId) else { return header }

        header.configureDelegate(self)
        header.configure(title: stationName, direction: "추후 변경해야함")
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
}

// MARK: - HomeSearchButtonDelegate : UICollectionView
extension HomeViewController: HomeSearchButtonDelegate {
    func shouldGoToSearchScene() {
        self.coordinator?.pushToSearch()
    }
}

// MARK: - AlarmButtonDelegate : UICollectionView
extension HomeViewController: AlarmButtonDelegate {
    func shouldGoToAlarmSettingScene(at indexPath: IndexPath) {
        self.coordinator?.pushToAlarmSetting(stationId: 118000007, busRouteId: 100100042, stationOrd: 49)
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
