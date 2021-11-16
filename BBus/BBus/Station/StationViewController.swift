//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit
import Combine

class StationViewController: UIViewController {
    
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
    private lazy var refreshButton: UIButton = {
        let radius: CGFloat = 25

        let button = UIButton()
        button.setImage(BBusImage.refresh, for: .normal)
        button.layer.cornerRadius = radius
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.darkGray
        
        button.addAction(UIAction(handler: { _ in
            self.viewModel?.refresh()
        }), for: .touchUpInside)
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

    // MARK: - Configure
    private func configureLayout() {
        let refreshButtonWidthAnchor: CGFloat = 50
        let refreshTrailingBottomInterval: CGFloat = -16

        self.view.addSubview(self.stationView)
        self.stationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.stationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.stationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.stationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        self.view.addSubview(self.customNavigationBar)
        self.customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.customNavigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.customNavigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.customNavigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        self.stationBusInfoHeight = nil

        self.view.addSubview(self.refreshButton)
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
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
            .sink(receiveValue: { [weak self] station in
                guard let station = station else { return }
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
        
        self.viewModel?.$busKeys
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.stationView.reload()
            })
            .store(in: &self.cancellables)
    }

    private func configureColor() {
        self.view.backgroundColor = BBusColor.bbusGray
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
        
        var busInfo: BusArriveInfo?
        if viewModel.infoBuses.count - 1 >= indexPath.section {
            let key = viewModel.busKeys[indexPath.section]
            busInfo = viewModel.infoBuses[key]?[indexPath.item]
        }
        else {
            let key = viewModel.busKeys[indexPath.section]
            busInfo = viewModel.noInfoBuses[key]?[indexPath.item]
        }
        
        if let busInfo = busInfo,
           let item = self.makeFavoriteItem(at: indexPath) {
            cell.configure(indexPath: indexPath)
            cell.configure(busNumber: busInfo.busNumber,
                           direction: busInfo.nextStation,
                           firstBusTime: busInfo.firstBusArriveRemainTime?.toString(),
                           firstBusRelativePosition: busInfo.firstBusRelativePosition,
                           firstBusCongestion: busInfo.congestion?.toString(),
                           secondBusTime: busInfo.secondBusArriveRemainTime?.toString(),
                           secondBusRelativePosition: busInfo.secondBusRelativePosition,
                           secondBusCongsetion: busInfo.congestion?.toString())
            cell.configure(delegate: self)
            cell.configureButton(status: viewModel.favoriteItems.contains(item))
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
    func likeStationBus(at indexPath: IndexPath) {
        guard let item = self.makeFavoriteItem(at: indexPath) else { return print("nil")}
        self.viewModel?.add(favoriteItem: item)
    }
    
    func cancelLikeStationBus(at indexPath: IndexPath) {
        guard let item = self.makeFavoriteItem(at: indexPath) else { return }
        self.viewModel?.remove(favoriteItem: item)
    }
    
    private func makeFavoriteItem(at indexPath: IndexPath) -> FavoriteItemDTO? {
        guard let viewModel = self.viewModel,
              let stationId = viewModel.usecase.stationInfo else { return nil }
        let key = viewModel.busKeys[indexPath.section]
        let item: FavoriteItemDTO
        if viewModel.infoBuses.count - 1 >= indexPath.section {
            guard let bus = viewModel.infoBuses[key]?[indexPath.item] else { return nil }
            item = FavoriteItemDTO(stId: "\(stationId)", busRouteId: "\(bus.busRouteId)", ord: "\(bus.stationOrd)", arsId: "\(bus.arsId)")
        }
        else {
            guard let bus = viewModel.noInfoBuses[key]?[indexPath.item] else { return nil }
            item = FavoriteItemDTO(stId: "\(stationId)", busRouteId: "\(bus.busRouteId)", ord: "\(bus.stationOrd)", arsId: "\(bus.arsId)")
        }
        return item
    }
}

// MARK: - Delegate: AlarmButton
extension StationViewController: AlarmButtonDelegate {
    func shouldGoToAlarmSettingScene(at indexPath: IndexPath) {
        guard let viewModel = viewModel,
              let stationId = viewModel.usecase.stationInfo?.stationID else { return }
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
        self.coordinator?.pushToAlarmSetting(stationId: stationId,
                                             busRouteId: bus.busRouteId,
                                             stationOrd: bus.stationOrd)
    }
}
