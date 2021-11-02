//
//  FavoriteHeader.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/02.
//

import UIKit

class FavoriteHeaderView: UITableViewHeaderFooterView {

    static let identifier = "FavoriteHeaderView"

    private lazy var stationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "여의도환승센터(4번승강장)"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private lazy var directionLabel: UILabel = {
        let label = UILabel()
        label.text = "여의도 공원 방면"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(named: "bbusGray")
        return label
    }()


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    private func configureLayout() {
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = UIColor.systemBackground

        self.addSubview(self.stationTitleLabel)
        self.stationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.stationTitleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        self.addSubview(self.directionLabel)
        self.directionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.directionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.directionLabel.topAnchor.constraint(equalTo: self.stationTitleLabel.bottomAnchor, constant: 5)
        ])
    }
}
