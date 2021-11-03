//
//  SearchBusView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class SearchBusView: UIView {

        
    var page: Bool { self.searchResultScrollView.contentOffset.x == 0 }
    private lazy var searchResultScrollView = SearchResultScrollView()
    private lazy var navigationView: SearchBusNavigationView = {
        let view = SearchBusNavigationView()
        view.backgroundColor = UIColor.systemBackground
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
        self.searchResultScrollView.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
        self.searchResultScrollView.configureLayout()
    }

    convenience init() {
        self.init(frame: CGRect())
    }

    // MARK: - Configuration
    private func configureLayout() {
        self.addSubview(self.navigationView)
        self.navigationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.navigationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.navigationView.heightAnchor.constraint(equalToConstant: 100),
            self.navigationView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.searchResultScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.searchResultScrollView)
        NSLayoutConstraint.activate([
            self.searchResultScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.searchResultScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.searchResultScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.searchResultScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }

    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        self.searchResultScrollView.configureDelegate(delegate)
    }
}
