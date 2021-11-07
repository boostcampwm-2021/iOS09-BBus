//
//  BusRouteView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class StationView: UIView {

    private lazy var stationScrollView = UIScrollView()
    private lazy var stationScrollContentsView = UIView()
    private lazy var stationHeaderView = BusRouteHeaderView()
    private lazy var stationBodyCollectionView: UICollectionView = {
        let collectionViewLeftInset: CGFloat = 90
        let collectionViewTopBottomRightInset: CGFloat = 0

        let layout = self.collectionViewLayout()
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.register(StationBodyCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        return collectionView
    }()

    convenience init() {
        self.init(frame: CGRect())
        
        self.configureLayout()
    }

    // MARK: - Configure
    private func configureLayout() {
        self.addSubview(self.stationScrollView)
        self.stationScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stationScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.stationScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stationScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.stationScrollContentsView.addSubview(self.stationHeaderView)
        self.stationHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationHeaderView.heightAnchor.constraint(equalToConstant: BusRouteHeaderView.headerHeight),
            self.stationHeaderView.leadingAnchor.constraint(equalTo: self.stationScrollContentsView.leadingAnchor),
            self.stationHeaderView.trailingAnchor.constraint(equalTo: self.stationScrollContentsView.trailingAnchor),
            self.stationHeaderView.topAnchor.constraint(equalTo: self.stationScrollContentsView.topAnchor)
        ])

        self.stationScrollContentsView.addSubview(self.stationBodyCollectionView)
        self.stationBodyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationBodyCollectionView.leadingAnchor.constraint(equalTo: self.stationScrollContentsView.leadingAnchor),
            self.stationBodyCollectionView.trailingAnchor.constraint(equalTo: self.stationScrollContentsView.trailingAnchor),
            self.stationBodyCollectionView.topAnchor.constraint(equalTo: self.stationHeaderView.bottomAnchor)
        ])

        self.stationScrollView.addSubview(self.stationScrollContentsView)
        self.stationScrollContentsView.translatesAutoresizingMaskIntoConstraints = false
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

    func configureTableViewHeight(height: CGFloat) -> NSLayoutConstraint {
        let constraint = self.stationBodyCollectionView.heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
        return constraint
    }

    func configureHeaderView(busType: String, busNumber: String, fromStation: String, toStation: String) {
        self.stationHeaderView.configure(busType: busType,
                                     busNumber: busNumber,
                                     fromStation: fromStation,
                                     toStation: toStation)
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let bottomLineHeight: CGFloat = 1
        let sectionInterval: CGFloat = 10

        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: bottomLineHeight, left: 0, bottom: sectionInterval, right: 0)
        layout.minimumInteritemSpacing = bottomLineHeight
        layout.minimumLineSpacing = bottomLineHeight
        return layout
    }
}
