//
//  HomeView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class HomeView: UIView {

    private lazy var favoriteTableView: UITableView = UITableView()
    private lazy var refreshButton: UIButton = UIButton()

    convenience init() {
        self.init(frame: CGRect())
        self.backgroundColor = .red
    }

    func configureLayout() {
        self.addSubview(self.favoriteTableView)
        self.favoriteTableView.backgroundColor = UIColor.blue
        self.favoriteTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.favoriteTableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.favoriteTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.favoriteTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.favoriteTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.addSubview(self.refreshButton)
        self.refreshButton.backgroundColor = UIColor.red
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.refreshButton.widthAnchor.constraint(equalToConstant: 50),
            self.refreshButton.heightAnchor.constraint(equalTo: self.refreshButton.widthAnchor),
            self.refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.refreshButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }

}
