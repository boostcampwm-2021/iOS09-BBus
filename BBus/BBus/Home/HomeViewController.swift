//
//  ViewController.swift
//  BBus
//
//  Created by Kang Minsang on 2021/10/26.
//

import UIKit

class HomeViewController: UIViewController {

    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeViewModel?
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "bbusLightGray")
        button.layer.borderColor = UIColor(named: "bbusGray")?.cgColor
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 3
        button.setTitle("버스 또는 정류장 검색", for: .normal)
        button.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    private lazy var homeView = HomeView()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"

        self.configureLayout()
        self.homeView.configureLayout()
        self.homeView.configureReusableCell()
        self.homeView.configureDelegate(self)
        self.addButtonAction()
    }

    private func configureLayout() {
        self.view.backgroundColor = UIColor.systemBackground

        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        self.searchButton.titleLabel?.leftAnchor.constraint(equalTo: self.searchButton.leftAnchor, constant: 10).isActive = true
        self.navigationItem.titleView = self.searchButton

        self.homeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.homeView)
        NSLayoutConstraint.activate([
            self.homeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.homeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.homeView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.homeView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func addButtonAction() {
        self.searchButton.addAction(UIAction.init(handler: { _ in
            self.coordinator?.pushToSearchBus()
        }), for: .touchUpInside)
    }
}

extension HomeViewController: UICollectionViewDelegate {

}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath)
                        as? FavoriteCollectionViewCell else { return UICollectionViewCell() }

        return cell
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.view.frame.width, height: 70)
    }
}
