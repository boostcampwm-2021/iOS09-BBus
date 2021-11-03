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
        static let navigationBack = UIImage.init(systemName: "chevron.left")
        static let headerArrow = UIImage.init(systemName: "arrow.left.and.right")
        static let stationCenterCircle = UIImage(named: "StationCenterCircle")
        static let tagMaxSize = UIImage(named: "BusTagMaxSize")
        static let tagMinSize = UIImage(named: "BusTagMinSize")
        static let blueBusIcon = UIImage(named: "busIcon")
    }
    
    private lazy var busRouteView = BusRouteView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureLayout()
        self.configureDelegate()
        self.configureStatusBarBackgroundColor(to: UIColor.systemBlue)
        self.configureTableView()
        self.busRouteView.addBusTag()
    }

    private func configureTableView() {
        self.busRouteView.busRouteTableView.delegate = self
        self.busRouteView.busRouteTableView.dataSource = self
    }
    
    private func configureStatusBarBackgroundColor(to color: UIColor) {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = color
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
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
    }

    private func configureLayout() {
        self.view.backgroundColor = UIColor.systemBackground
        
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
}

extension BusRouteViewController: UITableViewDataSource, UITableViewDelegate {
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BusStationTableViewCell.cellHeight
    }
}


extension BusRouteViewController: BackButtonDelegate {
    func touchedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
