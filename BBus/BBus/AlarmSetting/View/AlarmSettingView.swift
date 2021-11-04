//
//  AlarmSettingView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class AlarmSettingView: UIView {

    private lazy var alarmScrollView: UIScrollView = UIScrollView()

    private lazy var alarmScrollViewContentsView: UIView = UIView()

    lazy var alarmTableView: UITableView = {
        let tableViewLeftInset: CGFloat = 90
        let tableViewTopBottomRightInset: CGFloat = 0

        let tableView = UITableView()
        tableView.register(GetOnStatusCell.self, forCellReuseIdentifier: GetOnStatusCell.reusableID)
        tableView.separatorInset = UIEdgeInsets(top: tableViewTopBottomRightInset,
                                                left: tableViewLeftInset,
                                                bottom: tableViewTopBottomRightInset,
                                                right: tableViewTopBottomRightInset)
        tableView.separatorColor = AlarmSettingViewController.Color.tableViewSeperator
        tableView.backgroundColor = AlarmSettingViewController.Color.tableBackground
        return tableView
    }()

    lazy var reportWrongDataButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("잘못된 정보 신고", for: .normal)
        button.setTitleColor(AlarmSettingViewController.Color.lightGray, for: .normal)
        return button
    }()

    convenience init() {
        self.init(frame: CGRect())

        self.backgroundColor = AlarmSettingViewController.Color.tableBackground
        self.configureLayout()
    }

    func configureLayout() {
        self.addSubview(self.alarmScrollView)
        self.alarmScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.alarmScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.alarmScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.alarmScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.alarmScrollViewContentsView.addSubview(self.alarmTableView)
        self.alarmTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmTableView.heightAnchor.constraint(equalToConstant: 800),
            self.alarmTableView.leadingAnchor.constraint(equalTo: self.alarmScrollViewContentsView.leadingAnchor),
            self.alarmTableView.trailingAnchor.constraint(equalTo: self.alarmScrollViewContentsView.trailingAnchor),
            self.alarmTableView.topAnchor.constraint(equalTo: self.alarmScrollViewContentsView.topAnchor, constant: 20),
            self.alarmTableView.bottomAnchor.constraint(equalTo: self.alarmScrollViewContentsView.bottomAnchor, constant: -100)
        ])

        self.alarmScrollViewContentsView.addSubview(self.reportWrongDataButton)
        self.reportWrongDataButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.reportWrongDataButton.centerXAnchor.constraint(equalTo: self.alarmScrollViewContentsView.centerXAnchor),
            self.reportWrongDataButton.bottomAnchor.constraint(equalTo: self.alarmScrollViewContentsView.bottomAnchor, constant: -16)
        ])

        self.alarmScrollView.addSubview(self.alarmScrollViewContentsView)
        self.alarmScrollViewContentsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmScrollViewContentsView.topAnchor.constraint(equalTo: self.alarmScrollView.contentLayoutGuide.topAnchor),
            self.alarmScrollViewContentsView.leadingAnchor.constraint(equalTo: self.alarmScrollView.contentLayoutGuide.leadingAnchor),
            self.alarmScrollViewContentsView.trailingAnchor.constraint(equalTo: self.alarmScrollView.contentLayoutGuide.trailingAnchor),
            self.alarmScrollViewContentsView.bottomAnchor.constraint(equalTo: self.alarmScrollView.contentLayoutGuide.bottomAnchor),
            self.alarmScrollViewContentsView.widthAnchor.constraint(equalTo: self.alarmScrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    func configureDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource) {
        self.alarmTableView.delegate = delegate
        self.alarmTableView.dataSource = delegate
    }
}
