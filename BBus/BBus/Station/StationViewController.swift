//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit
import Combine

class StationViewController: UIViewController {

    enum Color {
        static let white = UIColor.white
        static let clear = UIColor.clear
        static let blueBus = UIColor.systemBlue
        static let tableViewSeperator = UIColor.systemGray6
        static let tableViewCellSubTitle = UIColor.systemGray
        static let tagBusNumber = UIColor.darkGray
        static let tagBusCongestion = UIColor.red
        static let greenLine = UIColor.green
        static let redLine = UIColor.red
        static let yellowLine = UIColor.yellow
    }

    enum Image {
        static let navigationBack = UIImage(systemName: "chevron.left")
        static let headerArrow = UIImage(systemName: "arrow.left.and.right")
        static let stationCenterCircle = UIImage(named: "StationCenterCircle")
        static let stationCenterGetOn = UIImage(named: "GetOn")
        static let stationCenterGetOff = UIImage(named: "GetOff")
        static let stationCenterUturn = UIImage(named: "Uturn")
        static let tagMaxSize = UIImage(named: "BusTagMaxSize")
        static let tagMinSize = UIImage(named: "BusTagMinSize")
        static let blueBusIcon = UIImage(named: "busIcon")
    }
    
    @Published private var stationBusInfoHeight: CGFloat = 100
    weak var coordinator: StationCoordinator?

    private lazy var customNavigationBar: CustomNavigationBar = {
        let bar = CustomNavigationBar()
        bar.configureTintColor(color: BBusColor.white)
        bar.configureAlpha(alpha: 0)
        if let bbusGray = BBusColor.bbusGray {
            bar.configureBackgroundColor(color: bbusGray)
        }
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.binding()
        self.configureLayout()
        self.configureDelegate()
        self.configureMOCKDATA()
        self.configureUI()
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
    }

    private func configureMOCKDATA() {
        self.customNavigationBar.configureBackButtonTitle("능곡초교")
        self.stationView.configureHeaderView(stationId: "25780",
                                             stationName: "능곡초교",
                                             direction: "시흥시노인종합복지관 방면")
    }

    private func configureUI() {
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationBodyCollectionViewCell.identifier, for: indexPath) as? StationBodyCollectionViewCell else { return UICollectionViewCell() }
        // height 재설정
        if collectionView.contentSize.height != self.stationBusInfoHeight {
            self.stationBusInfoHeight = collectionView.contentSize.height
        }
        cell.configure(busNumber: "58-A",
                       direction: "새보미아파트.고리울동굴시장 방향",
                       firstBusTime: "1분 29초",
                       firstBusRelativePosition: "2번째전",
                       firstBusCongestion: "여유",
                       secondBusTime: "9분 51초",
                       secondBusRelativePosition: "6번째전",
                       secondBusCongsetion: "여유")
        cell.configure(delegate: self)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: SimpleCollectionHeaderView.identifier,
                                                                           for: indexPath) as? SimpleCollectionHeaderView,
              let title = BBusRouteType.init(rawValue: 0)?.toString() else { return UICollectionReusableView() }

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
        self.customNavigationBar.configureAlpha(alpha: CGFloat(scrollView.contentOffset.y/127))
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
