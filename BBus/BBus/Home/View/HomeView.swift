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
        collectionView.register(FavoriteHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteHeaderView.identifier)
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        return collectionView
    }()
    private lazy var navigationView: HomeNavigationView = {
        let view = HomeNavigationView()
        view.backgroundColor = MyColor.white
        return view
    }()
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(MyImage.refresh, for: .normal)
        button.layer.cornerRadius = 25
        button.tintColor = UIColor.white
        return button
    }()

    convenience init() {
        self.init(frame: CGRect())
    }

    // MARK: - Configuration
    func configureLayout() {
        self.favoriteCollectionView.contentInsetAdjustmentBehavior = .never
        self.addSubview(self.favoriteCollectionView)
        self.favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.favoriteCollectionView.backgroundColor = MyColor.systemGray6
        NSLayoutConstraint.activate([
            self.favoriteCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.favoriteCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.favoriteCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.favoriteCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.addSubview(self.refreshButton)
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
        self.refreshButton.backgroundColor = UIColor.darkGray
        NSLayoutConstraint.activate([
            self.refreshButton.widthAnchor.constraint(equalToConstant: 50),
            self.refreshButton.heightAnchor.constraint(equalTo: self.refreshButton.widthAnchor),
            self.refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.refreshButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
        
        self.addSubview(self.navigationView)
        self.navigationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.navigationView.topAnchor.constraint(equalTo: self.topAnchor),
            self.navigationView.heightAnchor.constraint(equalToConstant: 50),
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
        UIView.animate(withDuration: TimeInterval(0.4), animations: {
            self.navigationView.transform = CGAffineTransform(translationX: 0, y: direction ? 0 : -49 )
        })
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        return layout
    }
}
