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

    private lazy var customNavigationBar: CustomNavigationBar = {
        let bar = CustomNavigationBar()
        bar.configureTintColor(color: BBusColor.white)
        if let bbusGray = BBusColor.bbusGray {
            bar.configureBackgroundColor(color: bbusGray)
        }
        bar.configureAlpha(alpha: 0)
        return bar
    }()
    private lazy var stationView: StationView = {
        let view = StationView()
        view.backgroundColor = BBusColor.white
        return view
    }()
    private lazy var refreshButton: ThrottleButton = {
        let radius: CGFloat = 25

        let button = ThrottleButton()
        button.setImage(BBusImage.refresh, for: .normal)
        button.layer.cornerRadius = radius
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.darkGray
        button.addTouchUpEventWithThrottle(delay: ThrottleButton.refreshInterval) { [weak self] in
            self?.viewModel?.refresh()
        }
        return button
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
        let refreshButtonWidthAnchor: CGFloat = 50
        let refreshTrailingBottomInterval: CGFloat = -16
        
        self.view.addSubviews(self.stationView, self.customNavigationBar, self.refreshButton)

        NSLayoutConstraint.activate([
            self.stationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.stationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.stationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.stationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            self.customNavigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.customNavigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.customNavigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        self.stationBusInfoHeight = nil

        NSLayoutConstraint.activate([
            self.refreshButton.widthAnchor.constraint(equalToConstant: refreshButtonWidthAnchor),
            self.refreshButton.heightAnchor.constraint(equalToConstant: refreshButtonWidthAnchor),
            self.refreshButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: refreshTrailingBottomInterval),
            self.refreshButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: refreshTrailingBottomInterval)
        ])
    }

    private func configureDelegate() {
        self.stationView.configureDelegate(self)
        self.customNavigationBar.configureDelegate(self)
    }
    
    private func binding() {
        self.$stationBusInfoHeight
            .receive(on: DispatchQueue.main)
            .sink() { [weak self] height in
                self?.collectionHeightConstraint?.isActive = false
                self?.collectionHeightConstraint = self?.stationView.configureTableViewHeight(height: height)
            }.store(in: &self.cancellables)
        
        self.viewModel?.usecase.$stationInfo
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] station in
                if let station = station {
                    self?.stationView.configureHeaderView(stationId: station.arsID, stationName: station.stationName)
                }
                else {
                    self?.noInfoAlert()
                }
            })
            .store(in: &self.cancellables)
        
        self.viewModel?.$nextStation
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] nextStation in
                guard let nextStation = nextStation else { return }
                self?.stationView.configureNextStation(direction: nextStation)
            })
            .store(in: &self.cancellables)
        
        self.viewModel?.$busKeys
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let viewModel = self?.viewModel else { return }

                self?.stationView.reload()

                if viewModel.stopLoader {
                    self?.stationView.stopLoader()
                }
            })
            .store(in: &self.cancellables)
        
        self.viewModel?.$favoriteItems
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .first()
            .sink(receiveValue: { [weak self] _ in
                self?.stationView.reload()
            })
            .store(in: &self.cancellables)
        
        self.viewModel?.usecase.$networkError
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                guard let _ = error else { return }
                self?.networkAlert()
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
                                           message: "죄송합니다. 현재 정보가 제공되지 않는 정거장입니다.",
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
        guard let viewModel = self.viewModel else { return }
        let busRouteId: Int
        let key = viewModel.busKeys[indexPath.section]
        if viewModel.infoBuses.count - 1 >= indexPath.section {
            busRouteId = viewModel.infoBuses[key]?[indexPath.item].busRouteId ?? 100100048
        }
        else {
            busRouteId = viewModel.noInfoBuses[key]?[indexPath.item].busRouteId ?? 100100048
        }
        self.coordinator?.pushToBusRoute(busRouteId: busRouteId)
    }
}

// MARK: - DataSource : CollectionView
extension StationViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.viewModel?.busKeys.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        if viewModel.infoBuses.count - 1 >= section {
            let key = viewModel.busKeys[section]
            return viewModel.infoBuses[key]?.count ?? 0
        }
        else {
            let key = viewModel.busKeys[section]
            return viewModel.noInfoBuses[key]?.count ?? 0
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
        if let item = self.makeFavoriteItem(at: indexPath) {
            cell.configure(delegate: self)
            cell.configureButton(status: viewModel.favoriteItems.contains(item))
            // 즐겨찾기 버튼 터치 시에도 reload 대신 버튼 색상만 다시 configure하도록 바인딩
            self.viewModel?.$favoriteItems
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak cell] favoriteItems in
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
        // TODO: maxCount 임시 조치, 추후 수정 필요
        if viewModel.infoBuses.count - 1 >= indexPath.section {
            self.viewModel?.$infoBuses
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] infoBuses in
                    guard let key = self?.viewModel?.busKeys[indexPath.section],
                          let maxCount = infoBuses[key]?.count,
                          let busInfo = maxCount > indexPath.item ? infoBuses[key]?[indexPath.item] : nil else { return }
                    configureCell(busInfo)
                })
                .store(in: &cell.cancellables)

            guard let key = self.viewModel?.busKeys[indexPath.section],
                  let maxCount = self.viewModel?.infoBuses[key]?.count,
                  let busInfo = maxCount > indexPath.item ? self.viewModel?.infoBuses[key]?[indexPath.item] : nil  else { return cell }

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
            let key = viewModel.busKeys[indexPath.section]
            if let busInfo = viewModel.noInfoBuses[key]?[indexPath.item] {
                configureCell(busInfo)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: SimpleCollectionHeaderView.identifier,
                                                                           for: indexPath) as? SimpleCollectionHeaderView,
              
                let title = self.viewModel?.busKeys[indexPath.section].toString() else { return UICollectionReusableView() }
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
            self.customNavigationBar.configureAlpha(alpha: 1)
        }
        else {
            self.customNavigationBar.configureAlpha(alpha: CGFloat(scrollView.contentOffset.y/baseLineContentOffset))
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
              let station = viewModel.usecase.stationInfo else { return nil }
        let key = viewModel.busKeys[indexPath.section]
        let item: FavoriteItemDTO
        if viewModel.infoBuses.count - 1 >= indexPath.section {
            guard let bus = viewModel.infoBuses[key]?[indexPath.item] else { return nil }
            item = FavoriteItemDTO(stId: "\(station.stationID)", busRouteId: "\(bus.busRouteId)", ord: "\(bus.stationOrd)", arsId: viewModel.arsId)
        }
        else {
            guard let bus = viewModel.noInfoBuses[key]?[indexPath.item] else { return nil }
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
              let stationID = viewModel.usecase.stationInfo?.stationID else { return }
        let key = viewModel.busKeys[indexPath.section]
        let bus: BusArriveInfo
        if viewModel.infoBuses.count - 1 >= indexPath.section {
            guard let info = viewModel.infoBuses[key]?[indexPath.item] else { return }
            bus = info
        }
        else {
            guard let info = viewModel.noInfoBuses[key]?[indexPath.item] else { return }
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
