//
//  ViewController.swift
//  BBus
//
//  Created by Kang Minsang on 2021/10/26.
//

import UIKit

class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel?
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

        self.configureLayout()
        self.homeView.configureLayout()
    }

    private func configureLayout() {
        self.view.backgroundColor = UIColor.yellow
        self.homeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.homeView)
        NSLayoutConstraint.activate([
            self.homeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.homeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.homeView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.homeView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

}

