//
//  BusTagView.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

class BusTagView: UIView {

    enum Image {
        static let maxSizeTag = "BusTagMaxSize"
        static let minSizeTag = "BusTagMinSize"
        static let busIcon = "busIcon"
    }

    private lazy var busIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Image.busIcon)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var busTagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Image.maxSizeTag)
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var busNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private lazy var busCongestionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private lazy var busStatusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.busNumberLabel, self.busCongestionLabel])
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()

    private lazy var lowFloorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private lazy var busTagFrameView = UIView()

    convenience init() {
        self.init(frame: CGRect())
        self.configureLayout()
        self.configureMockTagData()
    }

    private func configureLayout() {
        self.addSubview(self.busTagImageView)
        self.busTagImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busTagImageView.widthAnchor.constraint(equalToConstant: 70),
            self.busTagImageView.heightAnchor.constraint(equalToConstant: 35),
            self.busTagImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.busTagImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.busTagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.addSubview(self.busIconImageView)
        self.busIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busIconImageView.widthAnchor.constraint(equalToConstant: 20),
            self.busIconImageView.heightAnchor.constraint(equalToConstant: 20),
            self.busIconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.busIconImageView.leadingAnchor.constraint(equalTo: self.busTagImageView.trailingAnchor, constant: 2),
            self.busIconImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.busTagImageView.addSubview(self.busTagFrameView)
        self.busTagFrameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busTagFrameView.centerXAnchor.constraint(equalTo: self.busTagImageView.centerXAnchor),
            self.busTagFrameView.centerYAnchor.constraint(equalTo: self.busTagImageView.centerYAnchor)
        ])

        self.busTagFrameView.addSubview(self.busStatusStackView)
        self.busStatusStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busStatusStackView.topAnchor.constraint(equalTo: self.busTagFrameView.topAnchor),
//            self.busStatusStackView.leadingAnchor.constraint(equalTo: self.busTagFrameView.leadingAnchor),
//            self.busStatusStackView.trailingAnchor.constraint(equalTo: self.busTagFrameView.trailingAnchor),
            self.busStatusStackView.centerXAnchor.constraint(equalTo: self.busTagFrameView.centerXAnchor, constant: -4)
        ])

        self.busTagFrameView.addSubview(self.lowFloorLabel)
        self.lowFloorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.lowFloorLabel.topAnchor.constraint(equalTo: self.busStatusStackView.bottomAnchor),
            self.lowFloorLabel.leadingAnchor.constraint(equalTo: self.busTagFrameView.leadingAnchor),
            self.lowFloorLabel.trailingAnchor.constraint(equalTo: self.busTagFrameView.trailingAnchor),
            self.lowFloorLabel.bottomAnchor.constraint(equalTo: self.busTagFrameView.bottomAnchor)
        ])
    }

    private func configureMockTagData() {
        self.busNumberLabel.text = "6302"
        self.busCongestionLabel.text = "여유"
        self.lowFloorLabel.text = "저상"
    }
}