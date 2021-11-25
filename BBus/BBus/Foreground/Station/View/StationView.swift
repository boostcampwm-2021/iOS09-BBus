//
//  StationView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

final class StationView: UIView {

    private lazy var colorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = BBusColor.bbusGray
        return view
    }()
    private lazy var stationScrollView = UIScrollView()
    private lazy var stationScrollContentsView = UIView()
    private lazy var stationHeaderView = StationHeaderView()
    private lazy var stationBodyCollectionView: UICollectionView = {
        let collectionViewLeftInset: CGFloat = 90
        let collectionViewTopBottomRightInset: CGFloat = 0

        let layout = self.collectionViewLayout()
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.register(StationBodyCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        collectionView.register(SimpleCollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SimpleCollectionHeaderView.identifier)
        collectionView.register(SourceFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: SourceFooterView.identifier)
        collectionView.backgroundColor = BBusColor.bbusLightGray
        return collectionView
    }()

    convenience init() {
        self.init(frame: CGRect())
        
        self.configureLayout()
    }

    // MARK: - Configure
    private func configureLayout() {
        let half: CGFloat = 0.5
        
        self.addSubviews(self.colorBackgroundView, self.stationScrollView)

        NSLayoutConstraint.activate([
            self.colorBackgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: half),
            self.colorBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.colorBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.colorBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.stationScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stationScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.stationScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stationScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.stationScrollContentsView.addSubviews(self.stationHeaderView, self.stationBodyCollectionView)

        NSLayoutConstraint.activate([
            self.stationHeaderView.heightAnchor.constraint(equalToConstant: BusRouteHeaderView.headerHeight),
            self.stationHeaderView.leadingAnchor.constraint(equalTo: self.stationScrollContentsView.leadingAnchor),
            self.stationHeaderView.trailingAnchor.constraint(equalTo: self.stationScrollContentsView.trailingAnchor),
            self.stationHeaderView.topAnchor.constraint(equalTo: self.stationScrollContentsView.topAnchor)
        ])

        NSLayoutConstraint.activate([
            self.stationBodyCollectionView.leadingAnchor.constraint(equalTo: self.stationScrollContentsView.leadingAnchor),
            self.stationBodyCollectionView.trailingAnchor.constraint(equalTo: self.stationScrollContentsView.trailingAnchor),
            self.stationBodyCollectionView.topAnchor.constraint(equalTo: self.stationHeaderView.bottomAnchor)
        ])
        
        self.stationScrollView.addSubviews(self.stationScrollContentsView)
        
        NSLayoutConstraint.activate([
            self.stationScrollContentsView.topAnchor.constraint(equalTo: self.stationScrollView.contentLayoutGuide.topAnchor),
            self.stationScrollContentsView.leadingAnchor.constraint(equalTo: self.stationScrollView.contentLayoutGuide.leadingAnchor),
            self.stationScrollContentsView.trailingAnchor.constraint(equalTo: self.stationScrollView.contentLayoutGuide.trailingAnchor),
            self.stationScrollContentsView.bottomAnchor.constraint(equalTo: self.stationScrollView.contentLayoutGuide.bottomAnchor),
            self.stationScrollContentsView.widthAnchor.constraint(equalTo: self.stationScrollView.frameLayoutGuide.widthAnchor),
            self.stationScrollContentsView.heightAnchor.constraint(equalTo: self.stationBodyCollectionView.heightAnchor, constant: StationHeaderView.headerHeight)
        ])
    }

    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource & UIScrollViewDelegate) {
        self.stationBodyCollectionView.delegate = delegate
        self.stationBodyCollectionView.dataSource = delegate
        self.stationScrollView.delegate = delegate
    }

    func configureTableViewHeight(height: CGFloat?) -> NSLayoutConstraint {
        let layoutConstraint: NSLayoutConstraint = height == nil ? self.stationBodyCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor) : self.stationBodyCollectionView.heightAnchor.constraint(equalToConstant: height ?? 0)
        layoutConstraint.isActive = true
        return layoutConstraint
    }

    func configureHeaderView(stationId: String, stationName: String) {
        self.stationHeaderView.configureStationInfo(stationId: stationId, stationName: stationName)
    }
    
    func configureNextStation(direction: String) {
        self.stationHeaderView.configure(nextStationName: direction)
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let bottomLineHeight: CGFloat = 1

        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = bottomLineHeight
        layout.minimumLineSpacing = bottomLineHeight
        return layout
    }
    
    func reload() {
        self.stationBodyCollectionView.reloadData()
    }
    
    func indexPath(for cell: UICollectionViewCell) -> IndexPath? {
        return self.stationBodyCollectionView.indexPath(for: cell)
    }
}
