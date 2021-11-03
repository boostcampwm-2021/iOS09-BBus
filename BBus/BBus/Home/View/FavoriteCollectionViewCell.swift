//
//  FavoriteTableViewCell.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/02.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {

    static let identifier = "FavoriteCollectionViewCell"

    private lazy var busNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "272"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor(named: "bbusTypeBlue")
        return label
    }()
    private lazy var trailingView = BusCellTrailingView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.trailingView.configureLayout()
        self.configureLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.trailingView.configureLayout()
        self.configureLayout()
    }

    private func configureLayout() {
        self.addSubview(self.busNumberLabel)
        self.busNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.busNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])

        self.addSubview(self.trailingView)
        self.trailingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.trailingView.topAnchor.constraint(equalTo: self.topAnchor),
            self.trailingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.trailingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.trailingView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
    }
}
