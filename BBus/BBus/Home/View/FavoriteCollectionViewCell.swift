//
//  FavoriteTableViewCell.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/02.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {

    static let identifier = "FavoriteCollectionViewCell"
    var height: CGFloat { return 70 }
    var busNumberYAxisMargin: CGFloat { return 0 }
    var busNumberFontSize: CGFloat { return 22 }
    var busNumberLeadingInterval: CGFloat { return 20 }

    lazy var busNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "272"
        label.font = UIFont.boldSystemFont(ofSize: self.busNumberFontSize)
        label.textColor = MyColor.bbusTypeBlue
        return label
    }()
    lazy var trailingView = BusCellTrailingView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.trailingView.configureLayout()
        self.configureLayout()
        self.configureUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.trailingView.configureLayout()
        self.configureLayout()
        self.configureUI()
    }

    // MARK: - Configuration
    // Only uses Subclass
     func configureLayout() {
        let half: CGFloat = 0.5

        self.addSubview(self.busNumberLabel)
        let busNumberLeadingConstraint = self.busNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.busNumberLeadingInterval)
        busNumberLeadingConstraint.priority = UILayoutPriority.defaultHigh
        self.busNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: self.busNumberYAxisMargin),
            busNumberLeadingConstraint
        ])

        self.addSubview(self.trailingView)
        self.trailingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.trailingView.topAnchor.constraint(equalTo: self.topAnchor),
            self.trailingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.trailingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.trailingView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: half)
        ])
    }

    func configureDelegate(_ delegate: AlarmButtonDelegate) {
        self.trailingView.configureDelegate(delegate)
    }

    private func configureUI() {
        self.backgroundColor = MyColor.white
    }
}
