//
//  SearchResultScrollView.swift
//  BBus
//
//  Created by 이지수 on 2021/11/04.
//

import UIKit

class SearchResultScrollView: UIScrollView {

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func configureLayout() {
        let twice: CGFloat = 2
        let half: CGFloat = 0.5
        
        let contentView = UIView()
        
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor, multiplier: twice),
            contentView.heightAnchor.constraint(equalTo: self.frameLayoutGuide.heightAnchor)
        ])
        
        contentView.addSubview(self.busResultCollectionView)
        self.busResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busResultCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.busResultCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.busResultCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.busResultCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: half)
        ])
        
        contentView.addSubview(self.stationResultCollectionView)
        self.stationResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func configureUI() {
        let twice: CGFloat = 2
        
        self.isPagingEnabled = true
        self.contentSize = CGSize(width: self.frame.width * twice, height: self.frame.height)
    }
}
