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
            self.alarmButton.addAction(UIAction(handler: { _ in
                self.alarmButtonDelegate?.shouldGoToAlarmSettingScene()
            }), for: .touchUpInside)
        }
    }

    private lazy var firstBusTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "1분 29초"
        return label
    }()
    private lazy var secondBusTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "9분 51초"
        return label
    }()
    private lazy var firstBusTimeRightLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor(named: "bbusLightGray")?.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 3
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor(named: "bbusGray")
        label.attributedText = NSAttributedString()
        let fullText = "2번째전 여유"
        let range = (fullText as NSString).range(of: "여유")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "bbusCongestionRed") as Any, range: range)
        label.attributedText = attributedString
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    private lazy var secondBusTimeRightLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor(named: "bbusLightGray")?.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 3
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor(named: "bbusGray")
        label.attributedText = NSAttributedString()
        let fullText = "6번째전 여유"
        let range = (fullText as NSString).range(of: "여유")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "bbusCongestionRed") as Any, range: range)
        label.attributedText = attributedString
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    private lazy var alarmButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: "alarm", withConfiguration: largeConfig), for: .normal)
        button.tintColor = UIColor(named: "bbusGray")
        return button
    }()

    func configureLayout() {
        self.addSubview(self.firstBusTimeLabel)
        self.firstBusTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstBusTimeLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -3),
            self.firstBusTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])

        self.addSubview(self.secondBusTimeLabel)
        self.secondBusTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.secondBusTimeLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 3),
            self.secondBusTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])

        self.addSubview(self.firstBusTimeRightLabel)
        self.firstBusTimeRightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstBusTimeRightLabel.centerYAnchor.constraint(equalTo: self.firstBusTimeLabel.centerYAnchor),
            self.firstBusTimeRightLabel.leadingAnchor.constraint(equalTo: self.firstBusTimeLabel.trailingAnchor, constant: 4),
            self.firstBusTimeRightLabel.widthAnchor.constraint(equalToConstant: self.firstBusTimeRightLabel.frame.width + 10),
            self.firstBusTimeRightLabel.heightAnchor.constraint(equalToConstant: self.firstBusTimeRightLabel.frame.height + 5)
        ])

        self.addSubview(self.secondBusTimeRightLabel)
        self.secondBusTimeRightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.secondBusTimeRightLabel.centerYAnchor.constraint(equalTo: self.secondBusTimeLabel.centerYAnchor),
            self.secondBusTimeRightLabel.leadingAnchor.constraint(equalTo: self.secondBusTimeLabel.trailingAnchor, constant: 4),
            self.secondBusTimeRightLabel.widthAnchor.constraint(equalToConstant: self.secondBusTimeRightLabel.frame.width + 10),
            self.secondBusTimeRightLabel.heightAnchor.constraint(equalToConstant: self.secondBusTimeRightLabel.frame.height + 5)
        ])

        self.addSubview(self.alarmButton)
        self.alarmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmButton.widthAnchor.constraint(equalToConstant: 20),
            self.alarmButton.heightAnchor.constraint(equalTo: self.alarmButton.widthAnchor),
            self.alarmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.alarmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }

    func configureDelegate(_ delegate: AlarmButtonDelegate) {
        self.alarmButtonDelegate = delegate
    }
}
