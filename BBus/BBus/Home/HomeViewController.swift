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
        self.addButtonAction()
        self.homeView.configureDelegate(self)
    }

    private func configureLayout() {
        self.view.backgroundColor = UIColor.systemBackground

        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
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

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath)
                as? FavoriteTableViewCell else { return UITableViewCell() }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        10
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FavoriteHeaderView.identifier)
                as? FavoriteHeaderView else { return UIView() }

        return header
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }
}
