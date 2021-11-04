//
//  SearchBusView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class SearchBusView: UIView {

    private lazy var searchResultScrollView = SearchResultScrollView()
    var page: Bool { self.searchResultScrollView.contentOffset.x == 0 }
    
    // MARK: - Configuration
    func configureLayout() {
        self.searchResultScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.searchResultScrollView)
        NSLayoutConstraint.activate([
            self.searchResultScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.searchResultScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.searchResultScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.searchResultScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.searchResultScrollView.configureLayout()
    }

    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        self.searchResultScrollView.configureDelegate(delegate)
    }
}
