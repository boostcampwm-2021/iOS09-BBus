//
//  FavoriteHeader.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/02.
//

import UIKit

class FavoriteHeaderView: UICollectionReusableView {

    static let identifier = "FavoriteHeaderView"

    private lazy var stationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "여의도환승센터(4번승강장)"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    private lazy var directionLabel: UILabel = {
        let label = UILabel()
        label.text = "여의도 공원 방면"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "bbusGray")
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
        self.configureUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
        self.configureUI()
    }

    private func configureLayout() {

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

    private func configureUI() {
        self.backgroundColor = UIColor.systemBackground
    }
}
