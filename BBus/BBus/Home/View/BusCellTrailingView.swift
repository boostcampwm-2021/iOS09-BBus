//
//  BusCellTrailingView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/02.
//

import UIKit

protocol AlarmButtonDelegate {
    func shouldGoToAlarmSettingScene()
}

class BusCellTrailingView: UIView {

    private var alarmButtonDelegate: AlarmButtonDelegate? {
        didSet {
            let action = UIAction(handler: {_ in
                self.alarmButtonDelegate?.shouldGoToAlarmSettingScene()
            })
            self.alarmButton.removeTarget(nil, action: nil, for: .allEvents)
            self.alarmButton.addAction(action, for: .touchUpInside)
        }
    }
    private lazy var firstBusTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private lazy var secondBusTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private lazy var firstBusTimeRightLabel = RemainCongestionBadgeLabel()
    private lazy var secondBusTimeRightLabel = RemainCongestionBadgeLabel()
    private lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(BBusImage.alarm, for: .normal)
        button.tintColor = BBusColor.bbusGray
        return button
    }()

    // MARK: - Configuration
    func configureLayout() {
        let centerYInterval: CGFloat = 3

        self.addSubview(self.firstBusTimeLabel)
        self.firstBusTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstBusTimeLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -centerYInterval),
            self.firstBusTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])

        self.addSubview(self.secondBusTimeLabel)
        self.secondBusTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.secondBusTimeLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: centerYInterval),
            self.secondBusTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])

        let trailingViewLabelsInterval: CGFloat = 4
        self.addSubview(self.firstBusTimeRightLabel)
        self.firstBusTimeRightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstBusTimeRightLabel.centerYAnchor.constraint(equalTo: self.firstBusTimeLabel.centerYAnchor),
            self.firstBusTimeRightLabel.leadingAnchor.constraint(equalTo: self.firstBusTimeLabel.trailingAnchor, constant: trailingViewLabelsInterval)
        ])

        self.addSubview(self.secondBusTimeRightLabel)
        self.secondBusTimeRightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.secondBusTimeRightLabel.centerYAnchor.constraint(equalTo: self.secondBusTimeLabel.centerYAnchor),
            self.secondBusTimeRightLabel.leadingAnchor.constraint(equalTo: self.secondBusTimeLabel.trailingAnchor, constant: trailingViewLabelsInterval)
        ])

        let alarmButtonWidth: CGFloat = 20
        let alarmButtonTrailingInterval: CGFloat = -20
        self.addSubview(self.alarmButton)
        self.alarmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmButton.widthAnchor.constraint(equalToConstant: alarmButtonWidth),
            self.alarmButton.heightAnchor.constraint(equalTo: self.alarmButton.widthAnchor),
            self.alarmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.alarmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: alarmButtonTrailingInterval)
        ])
    }

    func configureDelegate(_ delegate: AlarmButtonDelegate) {
        self.alarmButtonDelegate = delegate
    }
    
    func configure(firstBusTime: String, firstBusRemaining: String, firstBusCongestion: String, secondBusTime: String, secondBusRemaining: String, secondBusCongestion: String) {
        self.firstBusTimeLabel.text = firstBusTime
        self.firstBusTimeLabel.sizeToFit()
        
        self.secondBusTimeLabel.text = secondBusTime
        self.secondBusTimeLabel.sizeToFit()
        
        self.firstBusTimeRightLabel.configure(remaining: firstBusRemaining, congestion: firstBusCongestion)
        self.secondBusTimeRightLabel.configure(remaining: secondBusRemaining, congestion: secondBusCongestion)
    }
}
