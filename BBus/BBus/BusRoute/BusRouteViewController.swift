//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class BusRouteViewController: UIViewController {

    private lazy var busRouteView = BusRouteView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureLayout()
        self.configureStatusBarBackgroundColor(to: UIColor.systemBlue)
        self.configureNavigationBarBackgroundColor(to: UIColor.systemBlue)
        self.configureTableView()
        self.busRouteView.addBusTag()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.configureStatusBarBackgroundColor(to: UIColor.white)
        self.configureNavigationBarBackgroundColor(to: UIColor.white)
    }
    
    private func configureTableView() {
        self.busRouteView.busRouteTableView.delegate = self
        self.busRouteView.busRouteTableView.dataSource = self
    }
    
    private func configureNavigationBarBackgroundColor(to color: UIColor) {
        self.navigationController?.navigationBar.backgroundColor = color
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
            self.busRouteView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.busRouteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.busRouteView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.busRouteView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
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
            cell.configureLineColor(before: UIColor.green, after: UIColor.red)
        }
        else {
            cell.configureLineColor(before: UIColor.red, after: UIColor.green)
        }
        
        if indexPath.item == 0 {
            cell.configureLineColor(before: UIColor.clear, after: UIColor.red)
        }
        else if indexPath.item == 19 {
            cell.configureLineColor(before: UIColor.red, after: UIColor.clear)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BusStationTableViewCell.cellHeight
    }
}
