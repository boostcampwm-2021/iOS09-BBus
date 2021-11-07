//
//  StationBodyCollectionViewCell.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/07.
//

import UIKit

class StationBodyCollectionViewCell: FavoriteCollectionViewCell {

    override var height: CGFloat { return 100 }
    override var busNumberYAxisMargin: CGFloat { return self.busNumberFontSize / 2 }
    override var busNumberFontSize: CGFloat { return super.busNumberFontSize * super.height / self.height }
    override var busNumberLeadingInterval: CGFloat { return self.likeButton.frame.origin.x + self.likeButton.frame.width + 10 }

    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = MyColor.bbusLikeYellow
        button.setImage(MyImage.emptyStar, for: .normal)
        button.setImage(MyImage.filledStar, for: .selected)
        return button
    }()
    lazy var directionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.bbusGray
        return label
    }()

    override func configureLayout() {
        super.configureLayout()

        let likeButtonleadingInterval: CGFloat = 10
        let likeButtonHeightWidth: CGFloat = 40
        self.addSubview(self.likeButton)
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.likeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.likeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: likeButtonleadingInterval),
            self.likeButton.widthAnchor.constraint(equalToConstant: likeButtonHeightWidth),
            self.likeButton.heightAnchor.constraint(equalToConstant: likeButtonHeightWidth)
        ])

        let directionLabelTopInterval: CGFloat = 10
        self.addSubview(self.directionLabel)
        self.directionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.directionLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: directionLabelTopInterval),
            self.directionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.busNumberLeadingInterval)
        ])
    }
}
