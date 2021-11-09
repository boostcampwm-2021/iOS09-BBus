//
//  MovingStatusBusTagView.swift
//  BBus
//
//  Created by 최수정 on 2021/11/05.
//

import UIKit

class MovingStatusBusTagView: UIView {

    private lazy var booduckBusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = BBusImage.booduckBus
        return imageView
    }()
    private lazy var speechBubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = BBusImage.speechBubble
        imageView.tintColor = BBusColor.blueBus
        return imageView
    }()
    private lazy var movingStatusLabel: UILabel = {
        let labelFontSize: CGFloat = 13
        let numberOfLines = 2
        
        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        label.numberOfLines = numberOfLines
        label.text = "4정류장 남음"
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.configureLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureLayout()
    }
    
    private func configureLayout() {
        let speechBubbleWidth: CGFloat = 85
        let speechBubbleHeight: CGFloat = 45
        let movingStatusLabelTopBottomMargin: CGFloat = 3
        let movingStatusLabelLeftMargin: CGFloat = 15
        let movingStatusLabelRightMargin: CGFloat = -20
        let booduckImageHeight: CGFloat = 35
        let booduckBusImageRatio = CGFloat(5) / CGFloat(6)
        let booduckBusImageLeftMargin: CGFloat = 5
        
        self.addSubview(self.speechBubbleImageView)
        self.speechBubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.speechBubbleImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.speechBubbleImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.speechBubbleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.speechBubbleImageView.widthAnchor.constraint(equalToConstant: speechBubbleWidth),
            self.speechBubbleImageView.heightAnchor.constraint(equalToConstant: speechBubbleHeight)
        ])
        
        self.speechBubbleImageView.addSubview(self.movingStatusLabel)
        self.movingStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.movingStatusLabel.topAnchor.constraint(equalTo: self.speechBubbleImageView.topAnchor, constant: movingStatusLabelTopBottomMargin),
            self.movingStatusLabel.bottomAnchor.constraint(equalTo: self.speechBubbleImageView.bottomAnchor, constant: -movingStatusLabelTopBottomMargin),
            self.movingStatusLabel.leadingAnchor.constraint(equalTo: self.speechBubbleImageView.leadingAnchor, constant: movingStatusLabelLeftMargin),
            self.movingStatusLabel.trailingAnchor.constraint(equalTo: self.speechBubbleImageView.trailingAnchor, constant: movingStatusLabelRightMargin)
        ])
        
        self.addSubview(self.booduckBusImageView)
        self.booduckBusImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.booduckBusImageView.heightAnchor.constraint(equalToConstant: booduckImageHeight),
            self.booduckBusImageView.widthAnchor.constraint(equalTo: self.booduckBusImageView.heightAnchor, multiplier: booduckBusImageRatio),
            self.booduckBusImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.booduckBusImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.booduckBusImageView.leadingAnchor.constraint(equalTo: self.speechBubbleImageView.trailingAnchor, constant: booduckBusImageLeftMargin),
            self.booduckBusImageView.widthAnchor.constraint(equalTo: self.booduckBusImageView.heightAnchor, multiplier: booduckBusImageRatio)
        ])
    }
}
