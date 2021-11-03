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

    var coordinator: BusRouteCoordinator?
    
    enum Image {
        static let navigationBack = UIImage.init(systemName: "chevron.left")
        static let headerArrow = UIImage.init(systemName: "arrow.left.and.right")
        static let stationCenterCircle = UIImage(named: "StationCenterCircle")
        static let stationCenterGetOn = UIImage(named: "GetOn")
        static let stationCenterGetOff = UIImage(named: "GetOff")
        static let stationCenterUturn = UIImage(named: "Uturn")
        static let tagMaxSize = UIImage(named: "BusTagMaxSize")
        static let tagMinSize = UIImage(named: "BusTagMinSize")
        static let blueBusIcon = UIImage(named: "busIcon")
    }
    
    private lazy var busRouteView = BusRouteView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureBackgroundColor()
        self.configureLayout()
        self.configureDelegate()
        self.busRouteView.addBusTag()
        
        guard let navigationController = self.navigationController else { return }
        self.coordinator = BusRouteCoordinator(presenter: navigationController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            self.coordinator?.terminate()
        }
    }

    private func configureLayout() {
        self.busRouteView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.busRouteView)
        NSLayoutConstraint.activate([
            self.busRouteView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.busRouteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.busRouteView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.busRouteView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    private func configureDelegate() {
        self.busRouteView.configureDelegate(self)
    }
    
    private func configureBackgroundColor() {
        self.view.backgroundColor = Color.blueBus
    }
}

extension BusRouteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusStationTableViewCell.reusableID, for: indexPath) as? BusStationTableViewCell else { return UITableViewCell() }
        cell.configureMockData()
        if indexPath.item % 2 == 0 {
            cell.configureLineColor(before: BusRouteViewController.Color.greenLine, after: BusRouteViewController.Color.redLine)
        }
        else {
            cell.configureLineColor(before: BusRouteViewController.Color.redLine, after: BusRouteViewController.Color.greenLine)
        }
        
        if indexPath.item == 0 {
            cell.configureLineColor(before: BusRouteViewController.Color.clear, after: BusRouteViewController.Color.redLine)
        }
        else if indexPath.item == 19 {
            cell.configureLineColor(before: BusRouteViewController.Color.redLine, after: BusRouteViewController.Color.clear)
        }
        
        if indexPath.item == 10 {
            cell.configureCenterImage(type: .uturn)
        }
        else {
            cell.configureCenterImage(type: .circle)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.coordinator?.pushToStation()
    }
}

extension BusRouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BusStationTableViewCell.cellHeight
    }
}

extension BusRouteViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.busRouteView.customNavigationBar.configureAlpha(alpha: CGFloat(scrollView.contentOffset.y/127))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y >= 70 && scrollView.contentOffset.y < 127 {
            UIView.animate(withDuration: 0.05) {
                scrollView.contentOffset.y = 127
            }
        } else if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 70 {
            UIView.animate(withDuration: 0.05) {
                scrollView.contentOffset.y = 0
            }
        }
    }
}


extension BusRouteViewController: BackButtonDelegate {
    func touchedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
