//
//  SearchBusView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class SearchBusView: UIView {

    private lazy var searchResultScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    private lazy var busResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return tableView
    }()
    private lazy var stationResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return tableView
    }()
    
    func configureLayout() {
        self.searchResultScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.searchResultScrollView)
        NSLayoutConstraint.activate([
            self.searchResultScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.searchResultScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.searchResultScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.searchResultScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.searchResultScrollView.contentSize = CGSize(width: self.searchResultScrollView.frame.width * 2, height: self.searchResultScrollView.frame.height)
        self.searchResultScrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.searchResultScrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.searchResultScrollView.contentLayoutGuide.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.searchResultScrollView.contentLayoutGuide.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.searchResultScrollView.contentLayoutGuide.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: self.searchResultScrollView.frameLayoutGuide.widthAnchor, multiplier: 2),
            contentView.heightAnchor.constraint(equalTo: self.searchResultScrollView.frameLayoutGuide.heightAnchor)
        ])
        
        self.busResultTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self.busResultTableView)
        NSLayoutConstraint.activate([
            self.busResultTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.busResultTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.busResultTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.busResultTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
        
        self.stationResultTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self.stationResultTableView)
        NSLayoutConstraint.activate([
            self.stationResultTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.stationResultTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.stationResultTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.stationResultTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func configureReusableCell() {
        self.busResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        self.stationResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    }

    func configureDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource) {
        self.busResultTableView.delegate = delegate
        self.busResultTableView.dataSource = delegate
        self.stationResultTableView.delegate = delegate
        self.stationResultTableView.dataSource = delegate
    }
}
