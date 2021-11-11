//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit
import Combine

class BusRouteViewController: UIViewController {

    weak var coordinator: BusRouteCoordinator?
    private lazy var customNavigationBar = CustomNavigationBar()
    private lazy var busRouteView = BusRouteView()
    private let viewModel: BusRouteViewModel?
    private var cancellables: Set<AnyCancellable> = []

    private lazy var refreshButton: UIButton = {
        let radius: CGFloat = 25

        let button = UIButton()
        button.setImage(BBusImage.refresh, for: .normal)
        button.layer.cornerRadius = radius
        button.tintColor = BBusColor.white
        button.backgroundColor = BBusColor.darkGray
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureBusColor(to: BBusColor.bbusTypeBlue)
        self.configureLayout()
        self.configureDelegate()
        self.configureMOCKDATA()
        self.binding()
    }

    init(viewModel: BusRouteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
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
    
    private func configureBusColor(to color: UIColor?) {
        self.view.backgroundColor = color
        self.customNavigationBar.configureBackgroundColor(color: color)
        self.customNavigationBar.configureTintColor(color: BBusColor.white)
        self.customNavigationBar.configureAlpha(alpha: 0)
        self.busRouteView.configureColor(to: color)
    }

    private func configureMOCKDATA() {
        self.customNavigationBar.configureBackButtonTitle("272")

        for i in 1...20 {
            let location = CGFloat.random(in: (0...19))
            self.busRouteView.addBusTag(location: location,
                                        busIcon: BBusImage.blueBusIcon,
                                        busNumber: "6302",
                                        busCongestion: "혼잡",
                                        isLowFloor: i%2 == 0)
        }

//        self.busRouteView.configureHeaderView(busType: "간선 버스",
//                                              busNumber: "272",
//                                              fromStation: "면목동",
//                                              toStation: "남가좌동")
    }

    private func binding() {
        self.bindingBusRouteHeaderResult()
    }

    private func bindingBusRouteHeaderResult() {
        self.viewModel?.$header
            .receive(on: BusRouteUsecase.thread)
            .sink(receiveValue: { _ in
                guard let header = self.viewModel?.header else { return }
                DispatchQueue.main.async {
                    self.busRouteView.configureHeaderView(busType: header.routeType.rawValue+"버스",
                                                          busNumber: header.busRouteName,
                                                          fromStation: header.startStation,
                                                          toStation: header.endStation)
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: - DataSource : TableView
extension BusRouteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusRouteTableViewCell.reusableID, for: indexPath) as? BusRouteTableViewCell else { return UITableViewCell() }

        let beforeColor: UIColor
        if indexPath.item == 0 {
            beforeColor = BBusColor.clear
        }
        else if indexPath.item % 3 == 0 {
            beforeColor = BBusColor.green
        }
        else if indexPath.item % 3 == 1 {
            beforeColor = BBusColor.red
        }
        else {
            beforeColor = BBusColor.yellow
        }
        
        let afterColor: UIColor
        if indexPath.item == 19 {
            afterColor = BBusColor.clear
        }
        else if indexPath.item % 3 == 0 {
            afterColor = BBusColor.red
        }
        else if indexPath.item % 3 == 1 {
            afterColor = BBusColor.yellow
        }
        else {
            afterColor = BBusColor.green
        }
        
        cell.configure(beforeColor: beforeColor,
                       afterColor: afterColor,
                       title: "면복동",
                       description: "19283 | 04:00-23:50",
                       type: indexPath.item != 10 ? .waypoint : .uturn)

        return cell
    }
}

// MARK: - Delegate : UITableView
extension BusRouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.coordinator?.pushToStation(stationId: 3)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BusRouteTableViewCell.cellHeight
    }
}

// MARK: - Delegate : UIScrollView
extension BusRouteViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let baseLineContentOffset = BusRouteHeaderView.headerHeight - CustomNavigationBar.height
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
extension BusRouteViewController: BackButtonDelegate {
    func touchedBackButton() {
        self.coordinator?.terminate()
    }
}
