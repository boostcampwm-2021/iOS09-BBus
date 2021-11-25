//
//  BusTagView.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/02.
//

import UIKit

final class BusTagView: UIView {

    enum TagSizeType {
        case min, max
    }

    private lazy var busTagFrameView = UIView()
    private lazy var busIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var busTagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private lazy var busNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 11

        let label = UILabel()
        label.textColor = BBusColor.darkGray
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    private lazy var busCongestionLabel: UILabel = {
        let labelFontSize: CGFloat = 11

        let label = UILabel()
        label.textColor = BBusColor.bbusCongestionRed
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    private lazy var busStatusStackView: UIStackView = {
        let stackViewSpacing: CGFloat = 2

        let stackView = UIStackView(arrangedSubviews: [self.busNumberLabel, self.busCongestionLabel])
        stackView.axis = .horizontal
        stackView.spacing = stackViewSpacing
        return stackView
    }()
    private lazy var lowFloorLabel: UILabel = {
        let labelFontSize: CGFloat = 11

        let label = UILabel()
        label.textColor = BBusColor.darkGray
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    convenience init() {
        self.init(frame: CGRect())

        self.configureLayout()
    }

    // MARK: - Configure
    private func configureLayout() {
        let busIconImageViewWidthAnchor: CGFloat = 20
        let busIconImageViewHeightAnchor: CGFloat = 20
        let termBusTagImageViewToBusIconImageView: CGFloat = 2
        let busTagFrameViewCenterXAnchor: CGFloat = -2
        
        self.addSubviews(self.busTagImageView, self.busIconImageView)

        NSLayoutConstraint.activate([
            self.busTagImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.busTagImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.busTagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            self.busIconImageView.widthAnchor.constraint(equalToConstant: busIconImageViewWidthAnchor),
            self.busIconImageView.heightAnchor.constraint(equalToConstant: busIconImageViewHeightAnchor),
            self.busIconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.busIconImageView.leadingAnchor.constraint(equalTo: self.busTagImageView.trailingAnchor, constant: termBusTagImageViewToBusIconImageView),
            self.busIconImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.busTagImageView.addSubviews(self.busTagFrameView)
        
        NSLayoutConstraint.activate([
            self.busTagFrameView.centerXAnchor.constraint(equalTo: self.busTagImageView.centerXAnchor, constant: busTagFrameViewCenterXAnchor),
            self.busTagFrameView.centerYAnchor.constraint(equalTo: self.busTagImageView.centerYAnchor)
        ])

        self.busTagFrameView.addSubviews(self.busStatusStackView, self.lowFloorLabel)
        
        NSLayoutConstraint.activate([
            self.busStatusStackView.topAnchor.constraint(equalTo: self.busTagFrameView.topAnchor),
            self.busStatusStackView.centerXAnchor.constraint(equalTo: self.busTagFrameView.centerXAnchor)
        ])

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
        self.lowFloorLabel.text = ""
    }

    private func configureTagImage(isLowFloor: Bool) {
        let busTagImageViewWidthAnchor: CGFloat = 70
        let busTagImageviewHeightAnchorWithMaxSize: CGFloat = 35
        let busTagImageViewHeightAnchorWithMinSize: CGFloat = 20

        if isLowFloor {
            self.busTagImageView.image = BBusImage.tagMaxSize
            NSLayoutConstraint.activate([
                self.busTagImageView.widthAnchor.constraint(equalToConstant: busTagImageViewWidthAnchor),
                self.busTagImageView.heightAnchor.constraint(equalToConstant: busTagImageviewHeightAnchorWithMaxSize)
            ])
        }
        else {
            self.busTagImageView.image = BBusImage.tagMinSize
            NSLayoutConstraint.activate([
                self.busTagImageView.widthAnchor.constraint(equalToConstant: busTagImageViewWidthAnchor),
                self.busTagImageView.heightAnchor.constraint(equalToConstant: busTagImageViewHeightAnchorWithMinSize)
            ])
        }
    }

    func configure(busIcon: UIImage?, busNumber: String, busCongestion: String, isLowFloor: Bool) {
        self.busIconImageView.image = busIcon
        self.configureTagImage(isLowFloor: isLowFloor)
        self.busNumberLabel.text = busNumber
        self.busCongestionLabel.text = busCongestion
        self.lowFloorLabel.text = isLowFloor ? "저상" : ""
    }
}
