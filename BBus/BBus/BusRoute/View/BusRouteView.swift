//
//  BusRouteView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class BusRouteView: UIView {

    private lazy var busRouteScrollView = UIScrollView()
    private lazy var busRouteScrollContentsView = UIView()
    private lazy var busHeaderView = BusRouteHeaderView()
    private lazy var colorBackgroundView = UIView()
    private lazy var busRouteTableView: UITableView = {
        let tableViewLeftInset: CGFloat = 90
        let tableViewTopBottomRightInset: CGFloat = 0
        
        let tableView = UITableView()
        tableView.register(BusRouteTableViewCell.self, forCellReuseIdentifier: BusRouteTableViewCell.reusableID)
        tableView.separatorInset = UIEdgeInsets(top: tableViewTopBottomRightInset,
                                                left: tableViewLeftInset,
                                                bottom: tableViewTopBottomRightInset,
                                                right: tableViewTopBottomRightInset)
        tableView.separatorColor = BusRouteViewController.Color.tableViewSeperator
        return tableView
    }()
    
    convenience init() {
        self.init(frame: CGRect())

        self.backgroundColor = BusRouteViewController.Color.white
        self.configureLayout()
    }

    // MARK: - Configure
    private func configureLayout() {
        let colorBackgroundViewHeightMultiplier: CGFloat = 0.5
        
        self.addSubview(self.colorBackgroundView)
        self.colorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorBackgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: colorBackgroundViewHeightMultiplier),
            self.colorBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.colorBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.colorBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.addSubview(self.busRouteScrollView)
        self.busRouteScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busRouteScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.busRouteScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.busRouteScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.busRouteScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.busRouteScrollContentsView.addSubview(self.busHeaderView)
        self.busHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busHeaderView.heightAnchor.constraint(equalToConstant: BusRouteHeaderView.headerHeight),
            self.busHeaderView.leadingAnchor.constraint(equalTo: self.busRouteScrollContentsView.leadingAnchor),
            self.busHeaderView.trailingAnchor.constraint(equalTo: self.busRouteScrollContentsView.trailingAnchor),
            self.busHeaderView.topAnchor.constraint(equalTo: self.busRouteScrollContentsView.topAnchor)
        ])
        
        self.busRouteScrollContentsView.addSubview(self.busRouteTableView)
        self.busRouteTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busRouteTableView.leadingAnchor.constraint(equalTo: self.busRouteScrollContentsView.leadingAnchor),
            self.busRouteTableView.trailingAnchor.constraint(equalTo: self.busRouteScrollContentsView.trailingAnchor),
            self.busRouteTableView.topAnchor.constraint(equalTo: self.busHeaderView.bottomAnchor),
            self.busRouteTableView.bottomAnchor.constraint(equalTo: self.busRouteScrollContentsView.bottomAnchor)
        ])
        
        self.busRouteScrollView.addSubview(self.busRouteScrollContentsView)
        self.busRouteScrollContentsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busRouteScrollContentsView.topAnchor.constraint(equalTo: self.busRouteScrollView.contentLayoutGuide.topAnchor),
            self.busRouteScrollContentsView.leadingAnchor.constraint(equalTo: self.busRouteScrollView.contentLayoutGuide.leadingAnchor),
            self.busRouteScrollContentsView.trailingAnchor.constraint(equalTo: self.busRouteScrollView.contentLayoutGuide.trailingAnchor),
            self.busRouteScrollContentsView.bottomAnchor.constraint(equalTo: self.busRouteScrollView.contentLayoutGuide.bottomAnchor),
            self.busRouteScrollContentsView.widthAnchor.constraint(equalTo: self.busRouteScrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    func configureDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource & UIScrollViewDelegate) {
        self.busRouteTableView.delegate = delegate
        self.busRouteTableView.dataSource = delegate
        self.busRouteScrollView.delegate = delegate
    }

    func configureColor(to color: UIColor) {
        self.colorBackgroundView.backgroundColor = color
        self.busHeaderView.backgroundColor = color
    }

    func configureTableViewHeight(count: Int) {
        NSLayoutConstraint.activate([
            self.busRouteTableView.heightAnchor.constraint(equalToConstant: CGFloat(count)*BusRouteTableViewCell.cellHeight)
        ])
    }

    func configureHeaderView(busType: String, busNumber: String, fromStation: String, toStation: String) {
        self.busHeaderView.configure(busType: busType,
                                     busNumber: busNumber,
                                     fromStation: fromStation,
                                     toStation: toStation)
    }

    // MARK: - Create BusTag
    func addBusTag(location: CGFloat, busIcon: UIImage?, busNumber: String, busCongestion: String, isLowFloor: Bool) {
        let busTag = BusTagView()
        busTag.configure(busIcon: busIcon,
                         busNumber: busNumber,
                         busCongestion: busCongestion,
                         isLowFloor: isLowFloor)

        self.busRouteTableView.addSubview(busTag)
        busTag.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busTag.leadingAnchor.constraint(equalTo: self.busRouteTableView.leadingAnchor, constant: 5),
            busTag.centerYAnchor.constraint(equalTo: self.busRouteTableView.topAnchor, constant: (BusRouteTableViewCell.cellHeight/2) + location*BusRouteTableViewCell.cellHeight)
        ])
    }
}
