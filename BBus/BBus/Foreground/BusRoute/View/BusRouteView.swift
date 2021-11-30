//
//  BusRouteView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

final class BusRouteView: UIView {

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
        tableView.backgroundColor = BBusColor.white
        tableView.separatorColor = BBusColor.bbusLightGray
        return tableView
    }()
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = BBusColor.gray
        return loader
    }()
    private lazy var customNavigationBar = CustomNavigationBar()
    private lazy var refreshButton: UIButton = {
        let radius: CGFloat = 25

        let button = UIButton()
        button.setImage(BBusImage.refresh, for: .normal)
        button.layer.cornerRadius = radius
        button.tintColor = BBusColor.white
        button.backgroundColor = BBusColor.darkGray

        button.addAction(UIAction(handler: { [weak self] _ in
//            self?.viewModel?.refreshBusPos()
        }), for: .touchUpInside)
        return button
    }()
    private var busTags: [BusTagView] = []
    private var busIcon: UIImage?
    private var busRouteTableViewHeightConstraint: NSLayoutConstraint?
    private var tableViewMinHeight: CGFloat {
        return max(self.frame.height - BusRouteHeaderView.headerHeight, 0)
    }
    
    convenience init() {
        self.init(frame: CGRect())

        self.backgroundColor = BBusColor.white
        self.configureLayout()
    }

    // MARK: - Configure
    private func configureLayout() {
        let colorBackgroundViewHeightMultiplier: CGFloat = 0.5
        
        self.addSubviews(self.colorBackgroundView, self.busRouteScrollView, self.loader)
        
        NSLayoutConstraint.activate([
            self.colorBackgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: colorBackgroundViewHeightMultiplier),
            self.colorBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.colorBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.colorBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.busRouteScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.busRouteScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.busRouteScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.busRouteScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.busRouteScrollContentsView.addSubviews(self.busHeaderView, self.busRouteTableView)
        
        NSLayoutConstraint.activate([
            self.busHeaderView.heightAnchor.constraint(equalToConstant: BusRouteHeaderView.headerHeight),
            self.busHeaderView.leadingAnchor.constraint(equalTo: self.busRouteScrollContentsView.leadingAnchor),
            self.busHeaderView.trailingAnchor.constraint(equalTo: self.busRouteScrollContentsView.trailingAnchor),
            self.busHeaderView.topAnchor.constraint(equalTo: self.busRouteScrollContentsView.topAnchor)
        ])
        
        self.busRouteTableViewHeightConstraint = self.busRouteTableView.heightAnchor.constraint(equalToConstant: tableViewMinHeight)
        self.busRouteTableViewHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            self.busRouteTableView.leadingAnchor.constraint(equalTo: self.busRouteScrollContentsView.leadingAnchor),
            self.busRouteTableView.trailingAnchor.constraint(equalTo: self.busRouteScrollContentsView.trailingAnchor),
            self.busRouteTableView.topAnchor.constraint(equalTo: self.busHeaderView.bottomAnchor),
            self.busRouteTableView.bottomAnchor.constraint(equalTo: self.busRouteScrollContentsView.bottomAnchor)
        ])
        
        self.busRouteScrollView.addSubviews(self.busRouteScrollContentsView)
        NSLayoutConstraint.activate([
            self.busRouteScrollContentsView.topAnchor.constraint(equalTo: self.busRouteScrollView.contentLayoutGuide.topAnchor),
            self.busRouteScrollContentsView.leadingAnchor.constraint(equalTo: self.busRouteScrollView.contentLayoutGuide.leadingAnchor),
            self.busRouteScrollContentsView.trailingAnchor.constraint(equalTo: self.busRouteScrollView.contentLayoutGuide.trailingAnchor),
            self.busRouteScrollContentsView.bottomAnchor.constraint(equalTo: self.busRouteScrollView.contentLayoutGuide.bottomAnchor),
            self.busRouteScrollContentsView.widthAnchor.constraint(equalTo: self.busRouteScrollView.frameLayoutGuide.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func configureDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource & UIScrollViewDelegate & BackButtonDelegate) {
        self.busRouteTableView.delegate = delegate
        self.busRouteTableView.dataSource = delegate
        self.busRouteScrollView.delegate = delegate
        self.customNavigationBar.configureDelegate(delegate)
    }

    func configureColor(to color: UIColor?) {
        self.colorBackgroundView.backgroundColor = color
        self.busHeaderView.backgroundColor = color
        self.customNavigationBar.configureBackgroundColor(color: color)
        self.customNavigationBar.configureTintColor(color: BBusColor.white)
        self.customNavigationBar.configureAlpha(alpha: 0)
    }

    func configureTableViewHeight(count: Int) {
        let newHeight = CGFloat(count)*BusRouteTableViewCell.cellHeight

        if newHeight > tableViewMinHeight {
            self.busRouteTableViewHeightConstraint?.constant = CGFloat(count)*BusRouteTableViewCell.cellHeight
            self.layoutIfNeeded()
        }
    }

    func configureHeaderView(busType: String, busNumber: String, fromStation: String, toStation: String) {
        self.busHeaderView.configure(busType: busType,
                                     busNumber: busNumber,
                                     fromStation: fromStation,
                                     toStation: toStation)
    }

    func createBusTag(location: CGFloat, busIcon: UIImage?, busNumber: String, busCongestion: String, isLowFloor: Bool) -> BusTagView {
        let busTag = BusTagView()
        busTag.configure(busIcon: busIcon,
                         busNumber: busNumber,
                         busCongestion: busCongestion,
                         isLowFloor: isLowFloor)

        self.busRouteTableView.addSubviews(busTag)
        
        NSLayoutConstraint.activate([
            busTag.leadingAnchor.constraint(equalTo: self.busRouteTableView.leadingAnchor, constant: 5),
            busTag.centerYAnchor.constraint(equalTo: self.busRouteTableView.topAnchor, constant: (BusRouteTableViewCell.cellHeight/2) + location*BusRouteTableViewCell.cellHeight)
        ])

        return busTag
    }

    func reload() {
        self.busRouteTableView.reloadData()
    }

    func startLoader() {
        self.loader.isHidden = false
        self.loader.startAnimating()
    }

    func stopLoader() {
        self.loader.isHidden = true
        self.loader.stopAnimating()
    }
    
    func configureBusColor(type: RouteType) -> UIColor? {
        let color: UIColor?

        switch type {
        case .mainLine:
            color = BBusColor.bbusTypeBlue
            self.busIcon = BBusImage.blueBusIcon
        case .broadArea:
            color = BBusColor.bbusTypeRed
            self.busIcon = BBusImage.redBusIcon
        case .customized:
            color = BBusColor.bbusTypeGreen
            self.busIcon = BBusImage.greenBusIcon
        case .circulation:
            color = BBusColor.bbusTypeCirculation
            self.busIcon = BBusImage.circulationBusIcon
        case .lateNight:
            color = BBusColor.bbusTypeBlue
            self.busIcon = BBusImage.blueBusIcon
        case .localLine:
            color = BBusColor.bbusTypeGreen
            self.busIcon = BBusImage.greenBusIcon
        }

        self.configureColor(to: color)
        return color
    }
    
    func configureBusTags(buses: [BusPosInfo]) {
        self.busTags.forEach { $0.removeFromSuperview() }
        self.busTags.removeAll()
        
        buses.forEach { [weak self] bus in
            guard let self = self else { return }
            let tag = self.createBusTag(location: bus.location,
                                        busIcon: self.busIcon,
                                        busNumber: bus.number,
                                        busCongestion: bus.congestion.toString(),
                                        isLowFloor: bus.islower)
            self.busTags.append(tag)
        }
    }
    
    func configureBackButtonTitle(title: String) {
        self.customNavigationBar.configureBackButtonTitle(title)
    }
    
    func configureNavigationAlpha(alpha: CGFloat) {
        self.customNavigationBar.configureAlpha(alpha: alpha)
    }
}
