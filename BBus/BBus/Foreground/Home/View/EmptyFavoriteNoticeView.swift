//
//  EmptyFavoriteNoticeView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/18.
//

import UIKit

class EmptyFavoriteNoticeView: UIView {

    private lazy var noticeImage: UIImageView = {
        let imageView = UIImageView(image: BBusImage.homeFavoriteEmpty)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "다음버스 도착시간까지 알고 싶다면 즐겨찾기를 추가해보세요."
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = BBusColor.bbusGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    convenience init() {
        self.init(frame: CGRect())
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    private func configureLayout() {
        let half: CGFloat = 0.5
        let centerYInterval: CGFloat = -30

        self.addSubviews(self.noticeImage, self.noticeLabel)

        NSLayoutConstraint.activate([
            self.noticeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.noticeImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: centerYInterval),
            self.noticeImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: half),
            self.noticeImage.heightAnchor.constraint(equalTo: self.noticeImage.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            self.noticeLabel.topAnchor.constraint(equalTo: self.noticeImage.bottomAnchor, constant: 15),
            self.noticeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.noticeLabel.widthAnchor.constraint(equalTo: self.noticeImage.widthAnchor, multiplier: 1.2)
        ])
    }
}
