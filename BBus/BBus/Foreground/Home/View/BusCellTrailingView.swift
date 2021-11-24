//
//  BusCellTrailingView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/02.
//

import UIKit

protocol AlarmButtonDelegate: AnyObject {
    func shouldGoToAlarmSettingScene(at cell: UICollectionViewCell)
}

class BusCellTrailingView: UIView {
    
    static let noInfoMessage = "도착 정보 없음"

    private lazy var firstBusTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = BBusColor.black
        return label
    }()
    private lazy var secondBusTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = BBusColor.black
        return label
    }()
    private lazy var firstBusTimeRightLabel = RemainCongestionBadgeLabel()
    private lazy var secondBusTimeRightLabel = RemainCongestionBadgeLabel()
    private(set) lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(BBusImage.alarmOffIcon, for: .normal)
        button.setImage(BBusImage.alarmOnTintIcon, for: .selected)
        button.tintColor = BBusColor.bbusGray
        return button
    }()
    private lazy var busTimeMessageLabel: UILabel = {
        let label = UILabel()
        label.text = Self.noInfoMessage
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = BBusColor.bbusGray
        label.isHidden = true
        return label
    }()

    // MARK: - Configuration
    func configureLayout() {

        let alarmButtonWidth: CGFloat = 45
        let alarmButtonTrailingInterval: CGFloat = -10
        
        self.addSubviews(self.alarmButton, self.firstBusTimeLabel, self.secondBusTimeLabel, self.busTimeMessageLabel, self.firstBusTimeRightLabel, self.secondBusTimeRightLabel)
        
        NSLayoutConstraint.activate([
            self.alarmButton.widthAnchor.constraint(equalToConstant: alarmButtonWidth),
            self.alarmButton.heightAnchor.constraint(equalTo: self.alarmButton.widthAnchor),
            self.alarmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.alarmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: alarmButtonTrailingInterval)
        ])

        let centerYInterval: CGFloat = 3
        NSLayoutConstraint.activate([
            self.firstBusTimeLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -centerYInterval),
            self.firstBusTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.secondBusTimeLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: centerYInterval),
            self.secondBusTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.busTimeMessageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.busTimeMessageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])

        let trailingViewLabelsInterval: CGFloat = 4
        NSLayoutConstraint.activate([
            self.firstBusTimeRightLabel.centerYAnchor.constraint(equalTo: self.firstBusTimeLabel.centerYAnchor),
            self.firstBusTimeRightLabel.leadingAnchor.constraint(equalTo: self.firstBusTimeLabel.trailingAnchor, constant: trailingViewLabelsInterval)
        ])

        NSLayoutConstraint.activate([
            self.secondBusTimeRightLabel.centerYAnchor.constraint(equalTo: self.secondBusTimeLabel.centerYAnchor),
            self.secondBusTimeRightLabel.leadingAnchor.constraint(equalTo: self.secondBusTimeLabel.trailingAnchor, constant: trailingViewLabelsInterval)
        ])

    }

    func configure(firstBusTime: String?, firstBusRemaining: String?, firstBusCongestion: String?, secondBusTime: String?, secondBusRemaining: String?, secondBusCongestion: String?) {
        
        let isHidden = firstBusTime == nil
        self.busTimeMessageLabel.isHidden = !isHidden
        self.firstBusTimeLabel.isHidden = isHidden
        self.firstBusTimeRightLabel.isHidden = isHidden
        self.secondBusTimeLabel.isHidden = isHidden
        self.secondBusTimeRightLabel.isHidden = isHidden
        
        self.firstBusTimeLabel.text = firstBusTime
        self.firstBusTimeLabel.sizeToFit()
        
        self.secondBusTimeLabel.text = secondBusTime == nil ? Self.noInfoMessage : secondBusTime
        self.secondBusTimeLabel.textColor = secondBusTime == nil ? BBusColor.bbusGray : BBusColor.black
        self.secondBusTimeLabel.sizeToFit()
        
        self.firstBusTimeRightLabel.configure(remaining: firstBusRemaining, congestion: firstBusCongestion)
        self.secondBusTimeRightLabel.configure(remaining: secondBusRemaining, congestion: secondBusCongestion)
    }

    func configure(alarmButtonActive: Bool) {
        self.alarmButton.isSelected = alarmButtonActive
    }
}
