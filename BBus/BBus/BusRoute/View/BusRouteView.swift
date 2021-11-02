//
//  BusRouteView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class BusRouteView: UIView {
    
    private lazy var colorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue
        return view
    }()

    private lazy var busRouteScrollView: UIScrollView = UIScrollView()
    
    private lazy var busRouteScrollContentsView: UIView = UIView()
    
    private lazy var busHeaderView: BusRouteHeaderView = {
        let view = BusRouteHeaderView()
        view.backgroundColor = UIColor.systemBlue
        return view
    }()
    
    lazy var busRouteTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BusStationTableViewCell.self, forCellReuseIdentifier: BusStationTableViewCell.reusableID)
        tableView.backgroundColor = UIColor.cyan
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
        return tableView
    }()

    convenience init() {
        self.init(frame: CGRect())
        self.backgroundColor = UIColor.systemBackground
        self.configureLayout()
    }

    func configureLayout() {
        self.addSubview(self.colorBackgroundView)
        self.colorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.colorBackgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
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
            self.busHeaderView.heightAnchor.constraint(equalToConstant: 250),
            self.busHeaderView.leadingAnchor.constraint(equalTo: self.busRouteScrollContentsView.leadingAnchor),
            self.busHeaderView.trailingAnchor.constraint(equalTo: self.busRouteScrollContentsView.trailingAnchor),
            self.busHeaderView.topAnchor.constraint(equalTo: self.busRouteScrollContentsView.topAnchor)
        ])
        
        self.busRouteScrollContentsView.addSubview(self.busRouteTableView)
        self.busRouteTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busRouteTableView.heightAnchor.constraint(equalToConstant: 1600),
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
    
    func configureBusColor(to color: UIColor) {
        self.colorBackgroundView.backgroundColor = color
        self.busHeaderView.backgroundColor = color
    }

    func addBusTag() {
        for i in 1...10 {
            let busTag = BusTagView()
            self.busRouteTableView.addSubview(busTag)

            busTag.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                busTag.topAnchor.constraint(equalTo: self.busRouteTableView.topAnchor, constant: CGFloat(130+(i*130)))
            ])
        }
    }
}
