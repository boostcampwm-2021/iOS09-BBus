//
//  AlarmSettingView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

final class AlarmSettingView: UIView {
    
    static let tableViewSectionCount = 2
    static let tableViewHeaderHeight: CGFloat = 35

    private lazy var alarmTableView: UITableView = {
        let tableViewLeftInset: CGFloat = 90
        let tableViewTopBottomRightInset: CGFloat = 0

        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(GetOffTableViewCell.self, forCellReuseIdentifier: GetOffTableViewCell.reusableID)
        tableView.register(GetOnStatusCell.self, forCellReuseIdentifier: GetOnStatusCell.reusableID)
        tableView.register(NoneInfoTableViewCell.self, forCellReuseIdentifier: NoneInfoTableViewCell.reusableID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = BBusColor.bbusBackground
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        return loader
    }()

    convenience init() {
        self.init(frame: CGRect())

        self.backgroundColor = BBusColor.systemGray5
        self.configureLayout()
    }

    // MARK: - Configure
    private func configureLayout() {
        self.addSubviews(self.alarmTableView, self.loader)
        
        NSLayoutConstraint.activate([
            self.alarmTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.alarmTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.alarmTableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.alarmTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func configureDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource) {
        self.alarmTableView.delegate = delegate
        self.alarmTableView.dataSource = delegate
    }
    
    func reload() {
        self.alarmTableView.reloadData()
    }
    
    func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return self.alarmTableView.indexPath(for: cell)
    }

    func startLoader() {
        self.loader.isHidden = false
        self.loader.startAnimating()
    }

    func stopLoader() {
        self.loader.isHidden = true
        self.loader.stopAnimating()
    }
}
