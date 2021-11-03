//
//  HomeView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class HomeView: UIView {

    private lazy var favoriteCollectionView: UICollectionView = {
        UICollectionView(frame: CGRect(), collectionViewLayout: self.collectionViewLayout())
    }()

    lazy var refreshButton: UIButton = UIButton()

    convenience init() {
        self.init(frame: CGRect())
        self.backgroundColor = .red
        self.configureReusableCell()
    }

    func configureLayout() {
        self.favoriteCollectionView.contentInsetAdjustmentBehavior = .never
        self.addSubview(self.favoriteCollectionView)
        self.favoriteCollectionView.backgroundColor = UIColor.systemGray6
        self.favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.favoriteCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.favoriteCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.favoriteCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.favoriteCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.addSubview(self.refreshButton)
        self.refreshButton.backgroundColor = UIColor.darkGray
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.refreshButton.widthAnchor.constraint(equalToConstant: 50),
            self.refreshButton.heightAnchor.constraint(equalTo: self.refreshButton.widthAnchor),
            self.refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.refreshButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }

    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        self.favoriteCollectionView.delegate = delegate
        self.favoriteCollectionView.dataSource = delegate
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        print(self.frame)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.frame.width, height: 70)
        return layout
    }

    private func configureReusableCell() {
        self.favoriteCollectionView.register(FavoriteHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteHeaderView.identifier)
        self.favoriteCollectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
    }
}
