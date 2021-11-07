//
//  ViewController.swift
//  BBus
//
//  Created by Kang Minsang on 2021/10/26.
//

import UIKit

enum MyColor {
    static let gray = UIColor.gray
    static let darkGray = UIColor.darkGray
    static let white = UIColor.white
    static let black = UIColor.black
    static let clear = UIColor.clear
    static let blueBus = UIColor.systemBlue
    static let systemGray6 = UIColor.systemGray6
    static let bbusLightGray = UIColor(named: "bbusLightGray")
    static let bbusGray = UIColor(named: "bbusGray")
    static let bbusTypeBlue = UIColor(named: "bbusTypeBlue")
    static let bbusTypeRed = UIColor(named: "bbusTypeRed")
    static let bbusSearchRed = UIColor(named: "bbusSearchRed")
    static let bbusCongestionRed = UIColor(named: "bbusCongestionRed")
    static let bbusLikeYellow = UIColor(named: "bbusLikeYellow")
}

enum MyImage {
    static let refresh: UIImage? = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        return UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: largeConfig)
    }()
    static let alarm: UIImage? = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        return UIImage(systemName: "alarm", withConfiguration: largeConfig)
    }()
    static let back: UIImage? = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        return UIImage(systemName: "chevron.left", withConfiguration: largeConfig)
    }()
    static let bus = UIImage(systemName: "bus.fill")
    static let station = UIImage(systemName: "bitcoinsign.circle")
    static let keyboardDown = UIImage(systemName: "keyboard.chevron.compact.down")
    static let filledStar: UIImage? = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        return UIImage(systemName: "star.fill", withConfiguration: largeConfig)
    }()
}

class HomeViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeViewModel?
    private lazy var homeView = HomeView()
    private var lastContentOffset: CGFloat = 0

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

        self.configureLayout()
        self.homeView.configureLayout()
        self.homeView.configureDelegate(self)
        
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height

        let statusbarView = UIView()
        statusbarView.backgroundColor = UIColor.white //컬러 설정 부분
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

    // MARK: - Configuration
    private func configureLayout() {
        self.view.backgroundColor = UIColor.systemBackground

        self.view.addSubview(self.homeView)
        self.homeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.homeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.homeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.homeView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.homeView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - Delegate : UICollectionView
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Model binding Logic needed

        self.coordinator?.pushToBusRoute()
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
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath)
                        as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
        cell.configureDelegate(self)
        cell.configure(busNumber: "127",
                       firstBusTime: "1분 29초",
                       firstBusRelativePosition: "2번째전",
                       firstBusCongestion: "여유",
                       secondBusTime: "9분 51초",
                       secondBusRelativePosition: "6번째전",
                       secondBusCongsetion: "여유")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoriteHeaderView.identifier, for: indexPath) as? FavoriteHeaderView else { return UICollectionReusableView() }
        header.configureDelegate(self)
        return header
    }
}

// MARK: - DelegateFlowLayout : UICollectionView
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: height overriding needed
        return CGSize(width: self.view.frame.width, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.view.frame.width, height: FavoriteHeaderView.height + HomeNavigationView.height)
        }
        else {
            return CGSize(width: self.view.frame.width, height: FavoriteHeaderView.height)
        }
    }
}

// MARK: - HomeSearchButtonDelegate : UICollectionView
extension HomeViewController: HomeSearchButtonDelegate {
    func shouldGoToSearchBusScene() {
        self.coordinator?.pushToSearchBus()
    }
}

// MARK: - AlarmButtonDelegate : UICollectionView
extension HomeViewController: AlarmButtonDelegate {
    func shouldGoToAlarmSettingScene() {
        // TODO: Model binding Logic needed

        self.coordinator?.pushToAlarmSetting()
    }
}

// MARK: - FavoriteHeaderViewDelegate : UICollectionView
extension HomeViewController: FavoriteHeaderViewDelegate {
    func shouldGoToStationScene() {
        // TODO: Model binding Logic needed
        
        self.coordinator?.pushToStation()
    }
}
