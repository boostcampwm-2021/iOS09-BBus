//
//  HomeView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class HomeView: UIView {


    private lazy var favoriteCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: self.collectionViewLayout())
        collectionView.register(FavoriteCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteCollectionHeaderView.identifier)
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = BBusColor.bbusBackground
        collectionView.backgroundView = backgroundView
        return collectionView
    }()
    private lazy var navigationView: HomeNavigationView = {
        let view = HomeNavigationView()
        view.backgroundColor = BBusColor.white
        return view
    }()

    convenience init() {
        self.init(frame: CGRect())
    }

    // MARK: - Configuration
    func configureLayout() {
        self.addSubviews(self.favoriteCollectionView, self.navigationView)

        self.favoriteCollectionView.contentInsetAdjustmentBehavior = .never
        self.favoriteCollectionView.backgroundColor = BBusColor.bbusGray6
        NSLayoutConstraint.activate([
            self.favoriteCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.favoriteCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.favoriteCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.favoriteCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.navigationView.topAnchor.constraint(equalTo: self.topAnchor),
            self.navigationView.heightAnchor.constraint(equalToConstant: HomeNavigationView.height),
            self.navigationView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & HomeSearchButtonDelegate) {
        self.favoriteCollectionView.delegate = delegate
        self.favoriteCollectionView.dataSource = delegate
        self.navigationView.configureDelegate(delegate)
    }

    func configureNavigationViewVisable(_ direction: Bool) {
        let animationDuration: TimeInterval = 0.4

        UIView.animate(withDuration: animationDuration, animations: {
            self.navigationView.transform = CGAffineTransform(translationX: 0, y: direction ? 0 : -HomeNavigationView.height + 1)
        })
    }

    func reload() {
        self.favoriteCollectionView.reloadData()
    }

    func indexPath(for cell: UICollectionViewCell) -> IndexPath? {
        return self.favoriteCollectionView.indexPath(for: cell)
    }

    func getSectionByHeaderView(header: UICollectionReusableView) -> Int? {
        guard let section = self.favoriteCollectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
                .first(where: { header == self.favoriteCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: $0) })?
                .section else { return nil }
        
        return section
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
