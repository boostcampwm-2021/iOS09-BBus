//
//  StationViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit
import Combine

final class StationViewController: UIViewController {
    
    @Published private var stationBusInfoHeight: CGFloat?
    private var collectionViewMinHeight: CGFloat {
        let twice: CGFloat = 2
        return self.view.frame.height - (StationHeaderView.headerHeight*twice)
    }
    weak var coordinator: StationCoordinator?
    private let viewModel: StationViewModel?

    private lazy var stationView: StationView = {
        let view = StationView()
        view.backgroundColor = BBusColor.white
        return view
    }()
    private var collectionHeightConstraint: NSLayoutConstraint?
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: StationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.binding()
        self.configureColor()
        self.configureLayout()
        self.configureDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.stationView.startLoader()
        self.viewModel?.configureObserver()
        self.viewModel?.refresh()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel?.cancelObserver()
    }

    // MARK: - Configure
    private func configureLayout() {
        self.view.addSubviews(self.stationView)

        NSLayoutConstraint.activate([
            self.stationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.stationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.stationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.stationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.stationBusInfoHeight = nil
    }

    private func configureDelegate() {
        self.stationView.configureDelegate(self)
    }
    
    private func binding() {
        self.$stationBusInfoHeight
            .receive(on: DispatchQueue.main)
            .sink() { [weak self] height in
                self?.collectionHeightConstraint?.isActive = false
                self?.collectionHeightConstraint = self?.stationView.configureTableViewHeight(height: height)
            }.store(in: &self.cancellables)
        
        self.viewModel?.$stationInfo
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] station in
                self?.stationView.configureHeaderView(stationId: station.arsID, stationName: station.stationName)
            })
            .store(in: &self.cancellables)
        
        self.viewModel?.$nextStation
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] nextStation in
                guard let nextStation = nextStation else { return }
                self?.stationView.configureNextStation(direction: nextStation)
            })
            .store(in: &self.cancellables)
        
        self.viewModel?.$error
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                guard let error = error as? BBusAPIError else { return }
                
                switch error {
                case .invalidStationError:
                    self?.noInfoAlert()
                default:
                    self?.networkAlert()
                }
            })
            .store(in: &self.cancellables)

        self.viewModel?.$stopLoader
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isStop in
                if isStop {
                    self?.stationView.stopLoader()
                }
            })
            .store(in: &self.cancellables)
        
        guard let viewModel = viewModel else { return }
        viewModel.$busKeys
            .combineLatest(viewModel.$stationInfo.compactMap{$0}, viewModel.$favoriteItems.compactMap{$0}.first())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] results in
                self?.stationView.reload()
            })
            .store(in: &self.cancellables)
    }
    
    private func networkAlert() {
        let controller = UIAlertController(title: "네트워크 장애", message: "네트워크 장애가 발생하여 앱이 정상적으로 동작되지 않습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        controller.addAction(action)
        self.coordinator?.delegate?.presentAlertToNavigation(controller: controller, completion: nil)
    }

    private func configureColor() {
        self.view.backgroundColor = BBusColor.bbusGray
    }
    
    private func noInfoAlert() {
        let controller = UIAlertController(title: "정거장 에러",
                                           message: "서울 외 지역은 정거장 정보를 제공하지 않습니다. 죄송합니다",
                                           preferredStyle: .alert)
        let action = UIAlertAction(title: "확인",
                                   style: .default,
                                   handler: { [weak self] _ in self?.coordinator?.terminate() })
        controller.addAction(action)
        self.coordinator?.delegate?.presentAlertToNavigation(controller: controller, completion: nil)
    }
}

// MARK: - Delegate : CollectionView
extension StationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel,
              let key = viewModel.busKeys[indexPath.section] else { return }
        let busRouteId: Int

        if viewModel.activeBuses.count - 1 >= indexPath.section {
            busRouteId = viewModel.activeBuses[key]?[indexPath.item]?.busRouteId ?? 100100048
        }
        else {
            busRouteId = viewModel.inActiveBuses[key]?[indexPath.item]?.busRouteId ?? 100100048
        }
        self.coordinator?.pushToBusRoute(busRouteId: busRouteId)
    }
}

// MARK: - DataSource : CollectionView
extension StationViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.viewModel?.busKeys.count() ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel,
              let key = viewModel.busKeys[section] else { return 0 }
        if viewModel.activeBuses.count - 1 >= section {
            return viewModel.activeBuses[key]?.count() ?? 0
        }
        else {
            return viewModel.inActiveBuses[key]?.count() ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationBodyCollectionViewCell.identifier, for: indexPath) as? StationBodyCollectionViewCell,
              let viewModel = self.viewModel else { return UICollectionViewCell() }
        
        // height 재설정
        if collectionView.contentSize.height > self.collectionViewMinHeight {
            self.stationBusInfoHeight = collectionView.contentSize.height
        }
        
        // configure delegate and button
        if let item = self.makeFavoriteItem(at: indexPath),
           let favoriteItems = viewModel.favoriteItems {
            cell.configure(delegate: self)
            cell.configureButton(status: favoriteItems.contains(item))
            self.viewModel?.$favoriteItems
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak cell] favoriteItems in
                    guard let favoriteItems = favoriteItems else { return }
                    cell?.configureButton(status: favoriteItems.contains(item))
                })
                .store(in: &cell.cancellables)
        }
        
        let configureCell: (BusArriveInfo) -> Void = { [weak cell] busInfo in
            cell?.configure(busNumber: busInfo.busNumber,
                           routeType: busInfo.routeType.toRouteType(),
                           direction: busInfo.nextStation,
                           firstBusTime: busInfo.firstBusArriveRemainTime?.toString(),
                           firstBusRelativePosition: busInfo.firstBusRelativePosition,
                           firstBusCongestion: busInfo.firstBusCongestion?.toString(),
                           secondBusTime: busInfo.secondBusArriveRemainTime?.toString(),
                           secondBusRelativePosition: busInfo.secondBusRelativePosition,
                           secondBusCongestion: busInfo.secondBusCongestion?.toString())
        }
        
        // InfoBus인 경우: 바인딩
        if viewModel.activeBuses.count - 1 >= indexPath.section {
            self.viewModel?.$activeBuses
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] activeBuses in
                    guard let key = self?.viewModel?.busKeys[indexPath.section],
                          let busInfo = activeBuses[key]?[indexPath.item] else { return }
                    configureCell(busInfo)
                })
                .store(in: &cell.cancellables)

            guard let key = self.viewModel?.busKeys[indexPath.section],
                  let busInfo = self.viewModel?.activeBuses[key]?[indexPath.item] else { return cell }

            let getOnAlarmViewModel = GetOnAlarmController.shared.viewModel
            let getOffAlarmViewModel = GetOffAlarmController.shared.viewModel
            if (getOnAlarmViewModel?.getOnAlarmStatus.targetOrd == busInfo.stationOrd &&
               getOnAlarmViewModel?.getOnAlarmStatus.busRouteId == busInfo.busRouteId) || (
                getOffAlarmViewModel?.getOffAlarmStatus.arsId == self.viewModel?.arsId &&
                getOffAlarmViewModel?.getOffAlarmStatus.busRouteId == busInfo.busRouteId) {
                cell.configure(alarmButtonActive: true)
            }
            else {
                cell.configure(alarmButtonActive: false)
            }
        }
        // NoInfoBus인 경우: 바로 configure
        else {
            guard let key = viewModel.busKeys[indexPath.section] else { return cell }
            if let busInfo = viewModel.inActiveBuses[key]?[indexPath.item] {
                configureCell(busInfo)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: SimpleCollectionHeaderView.identifier,
                                                                           for: indexPath) as? SimpleCollectionHeaderView,
              
                let title = self.viewModel?.busKeys[indexPath.section]?.toString() else { return UICollectionReusableView() }
        header.configureLayout()
        header.configure(title: title)
        return header
    }
}

extension StationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: StationBodyCollectionViewCell.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: SimpleCollectionHeaderView.height)
    }
}

// MARK: - Delegate : UIScrollView
extension StationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.customNavigationBar.configureAlpha(alpha: CGFloat(scrollView.contentOffset.y/127))
        let baseLineContentOffset = StationHeaderView.headerHeight - CustomNavigationBar.height
        if scrollView.contentOffset.y >= baseLineContentOffset {
            self.stationView.navigationBar.configureAlpha(alpha: 1)
        }
        else {
            self.stationView.navigationBar.configureAlpha(alpha: CGFloat(scrollView.contentOffset.y/baseLineContentOffset))
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let animationBaselineOffset: CGFloat = 70
        let headerHeight: CGFloat = 127
        let headerTop: CGFloat = 0
        let animationDuration: TimeInterval = 0.05

        if scrollView.contentOffset.y >= animationBaselineOffset && scrollView.contentOffset.y < headerHeight {
            UIView.animate(withDuration: animationDuration) {
                scrollView.contentOffset.y = headerHeight
            }
        } else if scrollView.contentOffset.y > headerTop && scrollView.contentOffset.y < animationBaselineOffset {
            UIView.animate(withDuration: animationDuration) {
                scrollView.contentOffset.y = headerTop
            }
        }
    }
}

// MARK: - Delegate : BackButton
extension StationViewController: BackButtonDelegate {
    func touchedBackButton() {
        self.coordinator?.terminate()
    }
}

// MARK: - Delegate: RefreshButton
extension StationViewController: RefreshButtonDelegate {
    func buttonTapped() {
        self.viewModel?.refresh()
    }
}

// MARK: - Delegate: LikeButton
extension StationViewController: LikeButtonDelegate {
    func likeStationBus(at cell: UICollectionViewCell) {
        guard let indexPath = self.indexPath(for: cell),
              let item = self.makeFavoriteItem(at: indexPath) else { return }
        self.viewModel?.add(favoriteItem: item)
    }
    
    func cancelLikeStationBus(at cell: UICollectionViewCell) {
        guard let indexPath = self.indexPath(for: cell),
              let item = self.makeFavoriteItem(at: indexPath) else { return }
        self.viewModel?.remove(favoriteItem: item)
    }
    
    private func indexPath(for cell: UICollectionViewCell) -> IndexPath? {
        return self.stationView.indexPath(for: cell)
    }
    
    private func makeFavoriteItem(at indexPath: IndexPath) -> FavoriteItemDTO? {
        guard let viewModel = self.viewModel,
              let station = viewModel.stationInfo,
              let key = viewModel.busKeys[indexPath.section] else { return nil }
        let item: FavoriteItemDTO
        if viewModel.activeBuses.count - 1 >= indexPath.section {
            guard let bus = viewModel.activeBuses[key]?[indexPath.item] else { return nil }
            item = FavoriteItemDTO(stId: "\(station.stationID)", busRouteId: "\(bus.busRouteId)", ord: "\(bus.stationOrd)", arsId: viewModel.arsId)
        }
        else {
            guard let bus = viewModel.inActiveBuses[key]?[indexPath.item] else { return nil }
            item = FavoriteItemDTO(stId: "\(station.stationID)", busRouteId: "\(bus.busRouteId)", ord: "\(bus.stationOrd)", arsId: viewModel.arsId)
        }
        return item
    }
}

// MARK: - Delegate: AlarmButton
extension StationViewController: AlarmButtonDelegate {
    func shouldGoToAlarmSettingScene(at cell: UICollectionViewCell) {
        guard let indexPath = self.indexPath(for: cell),
              let viewModel = viewModel,
              let stationID = viewModel.stationInfo?.stationID,
              let key = viewModel.busKeys[indexPath.section] else { return }
        let bus: BusArriveInfo
        if viewModel.activeBuses.count - 1 >= indexPath.section {
            guard let info = viewModel.activeBuses[key]?[indexPath.item] else { return }
            bus = info
        }
        else {
            guard let info = viewModel.inActiveBuses[key]?[indexPath.item] else { return }
            bus = info
        }
        self.coordinator?.pushToAlarmSetting(stationId: stationID,
                                             busRouteId: bus.busRouteId,
                                             stationOrd: bus.stationOrd,
                                             arsId: viewModel.arsId,
                                             routeType: bus.routeType.toRouteType(),
                                             busName: bus.busNumber)
    }
}
