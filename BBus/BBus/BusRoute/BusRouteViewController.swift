//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class BusRouteViewController: UIViewController {

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
    private lazy var busRouteView = BusRouteView()
    weak var coordinator: BusRouteCoordinator?
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
        self.configureMOCKDATA()
    }

    // MARK: - Configure
    private func configureLayout() {
        let refreshButtonWidthAnchor: CGFloat = 50
        let refreshTrailingBottomInterval: CGFloat = -16

        self.view.addSubview(self.busRouteView)
        self.busRouteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busRouteView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.busRouteView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.busRouteView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.busRouteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        self.view.addSubview(self.customNavigationBar)
        self.customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.customNavigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.customNavigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.customNavigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        self.busRouteView.configureTableViewHeight(count: 20)

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
        self.busRouteView.configureDelegate(self)
        self.customNavigationBar.configureDelegate(self)
    }
    
    private func configureBusColor(to color: UIColor) {
        self.view.backgroundColor = color
        self.customNavigationBar.configureBackgroundColor(color: color)
        self.customNavigationBar.configureTintColor(color: BusRouteViewController.Color.white)
        self.customNavigationBar.configureAlpha(alpha: 0)
        self.busRouteView.configureColor(to: color)
    }

    private func configureMOCKDATA() {
        self.customNavigationBar.configureBackButtonTitle("272")

        for i in 1...20 {
            let location = CGFloat.random(in: (0...19))
            self.busRouteView.addBusTag(location: location,
                                        busIcon: Image.blueBusIcon,
                                        busNumber: "6302",
                                        busCongestion: "혼잡",
                                        isLowFloor: i%2 == 0)
        }

        self.busRouteView.configureHeaderView(busType: "간선 버스",
                                              busNumber: "272",
                                              fromStation: "면목동",
                                              toStation: "남가좌동")
    }
}

// MARK: - DataSource : TableView
extension BusRouteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusStationTableViewCell.reusableID, for: indexPath) as? BusStationTableViewCell else { return UITableViewCell() }

        cell.configure(beforeColor: BusRouteViewController.Color.greenLine,
                       afterColor: BusRouteViewController.Color.redLine,
                       title: "면복동",
                       description: "19283 | 04:00-23:50",
                       type: .waypoint)

        return cell
    }
}

// MARK: - Delegate : UITableView
extension BusRouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.coordinator?.pushToStation()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BusStationTableViewCell.cellHeight
    }
}

// MARK: - Delegate : UIScrollView
extension BusRouteViewController: UIScrollViewDelegate {
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
extension BusRouteViewController: BackButtonDelegate {
    func touchedBackButton() {
        self.coordinator?.terminate()
    }
}
