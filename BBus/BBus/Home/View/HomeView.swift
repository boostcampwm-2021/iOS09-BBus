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
    private lazy var navigationView = HomeNavigationView()
    private lazy var navigationBottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.isHidden = true
        return view
    }()
    lazy var refreshButton: UIButton = UIButton()

    convenience init() {
        self.init(frame: CGRect())
    }

    func configureLayout() {
        self.addSubview(self.navigationView)
        self.navigationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.navigationView.topAnchor.constraint(equalTo: self.topAnchor),
            self.navigationView.heightAnchor.constraint(equalToConstant: 50),
            self.navigationView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        self.navigationBottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.navigationBottomBorderView)
        NSLayoutConstraint.activate([
            self.navigationBottomBorderView.topAnchor.constraint(equalTo: self.topAnchor),
            self.navigationBottomBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationBottomBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.navigationBottomBorderView.heightAnchor.constraint(equalToConstant: 0.2)
        ])
        
        self.favoriteCollectionView.contentInsetAdjustmentBehavior = .never
        self.addSubview(self.favoriteCollectionView)
        self.favoriteCollectionView.backgroundColor = UIColor.systemGray6
        self.favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.favoriteCollectionView.topAnchor.constraint(equalTo: self.navigationView.bottomAnchor),
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

    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout) {
        self.favoriteCollectionView.delegate = delegate
        self.favoriteCollectionView.dataSource = delegate
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        return layout
    }

    func configureReusableCell() {
        self.favoriteCollectionView.register(FavoriteHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteHeaderView.identifier)
        self.favoriteCollectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
    }
}
