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
    private lazy var busResultCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: self.collectionViewLayout())
        collectionView.backgroundColor = UIColor(named: "bbusLightGray")
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collectionView.register(SearchResultHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultHeaderView.identifier)
        return collectionView
    }()
    private lazy var stationResultCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: self.collectionViewLayout())
        collectionView.backgroundColor = UIColor(named: "bbusLightGray")
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collectionView.register(SearchResultHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultHeaderView.identifier)
        return collectionView
    }()
    var page: Bool { self.searchResultScrollView.contentOffset.x == 0 }
    
    // MARK: - Configuration
    func configureLayout() {
        let twice: CGFloat = 2
        let half: CGFloat = 0.5
        
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
        self.searchResultScrollView.contentSize = CGSize(width: self.searchResultScrollView.frame.width * twice, height: self.searchResultScrollView.frame.height)
        self.searchResultScrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.searchResultScrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.searchResultScrollView.contentLayoutGuide.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.searchResultScrollView.contentLayoutGuide.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.searchResultScrollView.contentLayoutGuide.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: self.searchResultScrollView.frameLayoutGuide.widthAnchor, multiplier: twice),
            contentView.heightAnchor.constraint(equalTo: self.searchResultScrollView.frameLayoutGuide.heightAnchor)
        ])
        
        self.busResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self.busResultCollectionView)
        NSLayoutConstraint.activate([
            self.busResultCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.busResultCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.busResultCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.busResultCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: half)
        ])
        
        self.stationResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self.stationResultCollectionView)
        NSLayoutConstraint.activate([
            self.stationResultCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.stationResultCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.stationResultCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.stationResultCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: half)
        ])
    }

    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        self.busResultCollectionView.delegate = delegate
        self.busResultCollectionView.dataSource = delegate
        self.stationResultCollectionView.delegate = delegate
        self.stationResultCollectionView.dataSource = delegate
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let cellInterval: CGFloat = 1
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: cellInterval,
                                           left: 0,
                                           bottom: cellInterval,
                                           right: 0)
        layout.minimumInteritemSpacing = cellInterval
        layout.minimumLineSpacing = cellInterval
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }
}
