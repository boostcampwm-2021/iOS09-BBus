//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit
import Combine

class StationViewController: UIViewController {
    
    @Published private var stationBusInfoHeight: CGFloat = 100
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

        self.collectionHeightConstraint = self.stationView.configureTableViewHeight(height: self.stationBusInfoHeight)

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
            .receive(on: DispatchQueue.main, options: nil)
            .sink() { [weak self] height in
                self?.collectionHeightConstraint?.isActive = false
                self?.collectionHeightConstraint = self?.stationView.configureTableViewHeight(height: height)
            }.store(in: &self.cancellables)
        
        self.viewModel?.usecase.$stationInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] station in
                guard let station = station else { return }
                self?.stationView.configureHeaderView(stationId: station.arsID,
                                                      stationName: station.stationName,
                                                      direction: "")
            })
            .store(in: &self.cancellables)
        
        self.viewModel?.$noInfoBuses
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
        self.coordinator?.pushToBusRoute()
    }
}

// MARK: - DataSource : CollectionView
extension StationViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.viewModel?.noInfoBuses.count ?? 0) + (self.viewModel?.infoBuses.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        if viewModel.infoBuses.count - 1 >= section {
            let key = Array(viewModel.infoBuses.keys)[section]
            return viewModel.infoBuses[key]?.count ?? 0
        }
        else {
            let section = section - viewModel.infoBuses.count
            let key = Array(viewModel.noInfoBuses.keys)[section]
            return viewModel.noInfoBuses[key]?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationBodyCollectionViewCell.identifier, for: indexPath) as? StationBodyCollectionViewCell,
              let viewModel = self.viewModel else { return UICollectionViewCell() }
        // height 재설정
        if collectionView.contentSize.height != self.stationBusInfoHeight {
            self.stationBusInfoHeight = collectionView.contentSize.height
        }
        
        var busInfo: StationViewModel.BusArriveInfo?
        if viewModel.infoBuses.count - 1 >= indexPath.section {
            let key = Array(viewModel.infoBuses.keys)[indexPath.section]
            busInfo = viewModel.infoBuses[key]?[indexPath.item]
        }
        else {
            let section = indexPath.section - viewModel.infoBuses.count
            let key = Array(viewModel.noInfoBuses.keys)[section]
            busInfo = viewModel.noInfoBuses[key]?[indexPath.item]
        }
        
        if let busInfo = busInfo {
            cell.configure(busNumber: busInfo.busNumber,
                           direction: busInfo.nextStation,
                           firstBusTime: busInfo.firstBusArriveRemainTime,
                           firstBusRelativePosition: busInfo.firstBusRelativePosition ?? "",
                           firstBusCongestion: busInfo.congestion,
                           secondBusTime: busInfo.secondBusArriveRemainTime,
                           secondBusRelativePosition: busInfo.secondBusRelativePosition ?? "",
                           secondBusCongsetion: busInfo.congestion)
            cell.configure(delegate: self)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: SimpleCollectionHeaderView.identifier,
                                                                           for: indexPath) as? SimpleCollectionHeaderView,
              
                let viewModel = self.viewModel else { return UICollectionReusableView() }
        let title: String
        if viewModel.infoBuses.count - 1 >= indexPath.section {
            let key = Array(viewModel.infoBuses.keys)[indexPath.section]
            title = key.toString()
        }
        else {
            let section = indexPath.section - viewModel.infoBuses.count
            let key = Array(viewModel.noInfoBuses.keys)[section]
            title = key.toString()
        }
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
    func likeStationBus() {
        print("like button clicked")
    }
}

// MARK: - Delegate: AlarmButton
extension StationViewController: AlarmButtonDelegate {
    func shouldGoToAlarmSettingScene() {
        self.coordinator?.pushToAlarmSetting()
    }
}
