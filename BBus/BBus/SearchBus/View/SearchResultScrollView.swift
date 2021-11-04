//
//  SearchResultScrollView.swift
//  BBus
//
//  Created by 이지수 on 2021/11/04.
//

import UIKit

class SearchResultScrollView: UIScrollView {
    
    static let indicatorHeight: CGFloat = 3

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
    private lazy var leftFakeIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bbusTypeRed")
        return view
    }()
    private lazy var rightFakeIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bbusTypeRed")
        return view
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
        let quater: CGFloat = 0.25
        
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
            self.busResultCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultScrollView.indicatorHeight),
            self.busResultCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.busResultCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: half)
        ])
        
        contentView.addSubview(self.stationResultCollectionView)
        self.stationResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationResultCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.stationResultCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultScrollView.indicatorHeight),
            self.stationResultCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.stationResultCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: half)
        ])
        
        contentView.addSubview(self.leftFakeIndicatorView)
        self.leftFakeIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leftFakeIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.leftFakeIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.leftFakeIndicatorView.heightAnchor.constraint(equalToConstant: SearchResultScrollView.indicatorHeight),
            self.leftFakeIndicatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: quater)
        ])
        
        contentView.addSubview(self.rightFakeIndicatorView)
        self.rightFakeIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.rightFakeIndicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.rightFakeIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.rightFakeIndicatorView.heightAnchor.constraint(equalToConstant: SearchResultScrollView.indicatorHeight),
            self.rightFakeIndicatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        self.busResultCollectionView.delegate = delegate
        self.busResultCollectionView.dataSource = delegate
        self.stationResultCollectionView.delegate = delegate
        self.stationResultCollectionView.dataSource = delegate
    }
    
    func configureIndicator(_ moving: Bool) {
        self.leftFakeIndicatorView.isHidden = moving
        self.rightFakeIndicatorView.isHidden = moving
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
        
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        self.isDirectionalLockEnabled = true
        self.contentSize = CGSize(width: self.frame.width * twice, height: self.frame.height)
    }
}
