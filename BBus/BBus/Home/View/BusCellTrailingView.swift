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
    private lazy var firstBusTimeRightLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = MyColor.bbusLightGray?.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 3
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = MyColor.bbusGray
        label.textAlignment = .center
        return label
    }()
    private lazy var secondBusTimeRightLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = MyColor.bbusLightGray?.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 3
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = MyColor.bbusGray
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    private lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(MyImage.alarm, for: .normal)
        button.tintColor = MyColor.bbusGray
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
        let rightLabelWidthPadding: CGFloat = 10
        let rightLabelHeightPadding: CGFloat = 5
        self.addSubview(self.firstBusTimeRightLabel)
        self.firstBusTimeRightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstBusTimeRightLabel.centerYAnchor.constraint(equalTo: self.firstBusTimeLabel.centerYAnchor),
            self.firstBusTimeRightLabel.leadingAnchor.constraint(equalTo: self.firstBusTimeLabel.trailingAnchor, constant: trailingViewLabelsInterval),
//            self.firstBusTimeRightLabel.widthAnchor.constraint(equalToConstant: self.firstBusTimeRightLabel.frame.width + rightLabelWidthPadding),
//            self.firstBusTimeRightLabel.heightAnchor.constraint(equalToConstant: self.firstBusTimeRightLabel.frame.height + rightLabelHeightPadding)
        ])

        self.addSubview(self.secondBusTimeRightLabel)
        self.secondBusTimeRightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.secondBusTimeRightLabel.centerYAnchor.constraint(equalTo: self.secondBusTimeLabel.centerYAnchor),
            self.secondBusTimeRightLabel.leadingAnchor.constraint(equalTo: self.secondBusTimeLabel.trailingAnchor, constant: trailingViewLabelsInterval),
//            self.secondBusTimeRightLabel.widthAnchor.constraint(equalToConstant: self.secondBusTimeRightLabel.frame.width + rightLabelWidthPadding),
//            self.secondBusTimeRightLabel.heightAnchor.constraint(equalToConstant: self.secondBusTimeRightLabel.frame.height + rightLabelHeightPadding)
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
    
    func configure(firstBusTime: String, firstBusRelativePosition: String, firstBusCongestion: String, secondBusTime: String, secondBusRelativePosition: String, secondBusCongestion: String) {
        self.firstBusTimeLabel.text = firstBusTime
        self.firstBusTimeLabel.sizeToFit()
        
        self.secondBusTimeLabel.text = secondBusTime
        self.secondBusTimeLabel.sizeToFit()
        
        let firstBusDescription = firstBusRelativePosition + " " + firstBusCongestion
        let firstRange = (firstBusDescription as NSString).range(of: firstBusCongestion)
        let firstAttributedString = NSMutableAttributedString(string: firstBusDescription)
        firstAttributedString.addAttribute(.foregroundColor,
                                           value: MyColor.bbusCongestionRed as Any,
                                           range: firstRange)
        self.firstBusTimeRightLabel.attributedText = firstAttributedString
        self.firstBusTimeRightLabel.sizeToFit()
        
        let secondBusDescription = secondBusRelativePosition + " " + secondBusCongestion
        let secondRange = (secondBusDescription as NSString).range(of: secondBusCongestion)
        let secondAttributedString = NSMutableAttributedString(string: secondBusDescription)
        secondAttributedString.addAttribute(.foregroundColor,
                                            value: MyColor.bbusCongestionRed as Any,
                                            range: secondRange)
        self.secondBusTimeRightLabel.attributedText = secondAttributedString
        self.secondBusTimeRightLabel.sizeToFit()
    }
}
