//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

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

    private lazy var customNavigationBar = CustomNavigationBar()
    private lazy var stationView = StationView()
    weak var coordinator: StationCoordinator?
    private lazy var refreshButton: UIButton = {
        let radius: CGFloat = 25

        let button = UIButton()
        button.setImage(MyImage.refresh, for: .normal)
        button.layer.cornerRadius = radius
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.darkGray
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureBusColor(to: Color.blueBus)
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

        self.stationView.configureTableViewHeight(count: 20)

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
//        self.stationView.configureDelegate(self)
//        self.customNavigationBar.configureDelegate(self)
    }

    private func configureBusColor(to color: UIColor) {
        self.view.backgroundColor = color
        self.customNavigationBar.configureBackgroundColor(color: color)
        self.customNavigationBar.configureTintColor(color: BusRouteViewController.Color.white)
        self.customNavigationBar.configureAlpha(alpha: 0)
        self.stationView.configureColor(to: color)
    }
}

// MARK: - DataSource : TableView


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
