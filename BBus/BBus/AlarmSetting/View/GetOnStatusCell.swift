//
//  GetOnStatusCell.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/04.
//

import UIKit

class GetOnStatusCell: UITableViewCell {

    static let reusableID = "GetOnStatusCell"
    static let cellHeight: CGFloat = 120

    private lazy var busColorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = self.frame.width/2
        view.backgroundColor = AlarmSettingViewController.Color.blueBus
        return view
    }()
    private lazy var busOrderNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 8

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.white
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .center
        label.backgroundColor = .red
        return label
    }()
    private lazy var remainingTimeLabel: UILabel = {
        let labelFontSize: CGFloat = 20

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.black
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    private lazy var remainingStationCountLabel: UILabel = {
        let labelFontSize: CGFloat = 10

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.lightGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    private lazy var busCongestionStatusLabel: UILabel = {
        let labelFontSize: CGFloat = 10

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.red
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    private lazy var busStatusTagStackView: UIStackView = {
        let stackViewSpacing: CGFloat = 3
        let borderWidth: CGFloat = 1

        let stackView = UIStackView(arrangedSubviews: [self.remainingStationCountLabel, self.busCongestionStatusLabel])
        stackView.axis = .horizontal
        stackView.spacing = stackViewSpacing
        stackView.layer.borderWidth = borderWidth
        stackView.layer.borderColor = AlarmSettingViewController.Color.lightGray.cgColor
        return stackView
    }()
    private lazy var clockIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AlarmSettingViewController.Image.clockIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var locationIconImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = AlarmSettingViewController.Image.locationIcon
        imageView?.contentMode = .scaleAspectFit
        return imageview
    }()
    private lazy var busIconImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = AlarmSettingViewController.Image.busIcon
        imageView?.contentMode = .scaleAspectFit
        return imageview
    }()
    private lazy var arrivalTimeLabel: UILabel = {
        let labelFontSize: CGFloat = 15

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.darkGray
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .left
        return label
    }()
    private lazy var currentLocationLabel: UILabel = {
        let labelFontSize: CGFloat = 15

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.darkGray
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .left
        return label
    }()
    private lazy var busNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 15

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.darkGray
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .left
        return label
    }()
    private lazy var alarmButton: UIButton = {
        let borderWidth: CGFloat = 1

        let button = UIButton()
        button.setImage(AlarmSettingViewController.Image.alarmIcon, for: .normal)
        button.tintColor = AlarmSettingViewController.Color.darkGray
        button.clipsToBounds = true
        button.layer.cornerRadius = self.frame.width/2
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = AlarmSettingViewController.Color.lightGray.cgColor
        return button
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureLayout()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    // MARK: - Configure
    private func configureLayout() {
        let busColorViewTopAnchor: CGFloat = 15
        let busColorViewLeadingAnchor: CGFloat = 15
        let busColorViewWidthAnchor: CGFloat = 15
        let busColorViewHeightAnchor: CGFloat = 15
        let termBusColorViewToRemainingTimeLabel: CGFloat = 15
        let busStatusTagStackViewLeadingAnchor: CGFloat = 5
        let clockIconTopAnchor: CGFloat = 5
        let iconsVerticalTerm: CGFloat = 3
        let iconWidthAnchor: CGFloat = 15
        let iconHeightAnchor: CGFloat = 15
        let alarmButtonWidthAnchor: CGFloat = 25
        let alarmButtonHeightAnchor: CGFloat = 25
        let alarmButtonTrailingAnchor: CGFloat = -15
        let indicatorLabelLeadingAnchor: CGFloat = 5

        self.addSubview(self.busColorView)
        self.busColorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busColorView.widthAnchor.constraint(equalToConstant: busColorViewWidthAnchor),
            self.busColorView.heightAnchor.constraint(equalToConstant: busColorViewHeightAnchor),
            self.busColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: busColorViewTopAnchor),
            self.busColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: busColorViewLeadingAnchor)
        ])

        self.busColorView.addSubview(self.busOrderNumberLabel)
        self.busOrderNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busOrderNumberLabel.centerXAnchor.constraint(equalTo: self.busColorView.centerXAnchor),
            self.busOrderNumberLabel.centerYAnchor.constraint(equalTo: self.busColorView.centerYAnchor)
        ])

        self.addSubview(self.remainingTimeLabel)
        self.remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.remainingTimeLabel.centerYAnchor.constraint(equalTo: self.busColorView.centerYAnchor),
            self.remainingTimeLabel.leadingAnchor.constraint(equalTo: self.busColorView.trailingAnchor, constant: termBusColorViewToRemainingTimeLabel)
        ])

        self.addSubview(self.busStatusTagStackView)
        self.busStatusTagStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busStatusTagStackView.centerYAnchor.constraint(equalTo: self.remainingTimeLabel.centerYAnchor),
            self.busStatusTagStackView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.trailingAnchor, constant: busStatusTagStackViewLeadingAnchor)
        ])

        self.addSubview(self.clockIconImageView)
        self.clockIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.clockIconImageView.widthAnchor.constraint(equalToConstant: iconWidthAnchor),
            self.clockIconImageView.heightAnchor.constraint(equalToConstant: iconHeightAnchor),
            self.clockIconImageView.topAnchor.constraint(equalTo: self.remainingTimeLabel.bottomAnchor, constant: clockIconTopAnchor),
            self.clockIconImageView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.leadingAnchor)
        ])

        self.addSubview(self.arrivalTimeLabel)
        self.arrivalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.arrivalTimeLabel.leadingAnchor.constraint(equalTo: self.clockIconImageView.trailingAnchor, constant: indicatorLabelLeadingAnchor),
            self.arrivalTimeLabel.centerYAnchor.constraint(equalTo: self.clockIconImageView.centerYAnchor)
        ])

        self.addSubview(self.locationIconImageView)
        self.locationIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.locationIconImageView.widthAnchor.constraint(equalToConstant: iconWidthAnchor),
            self.locationIconImageView.heightAnchor.constraint(equalToConstant: iconHeightAnchor),
            self.locationIconImageView.topAnchor.constraint(equalTo: self.clockIconImageView.bottomAnchor, constant: iconsVerticalTerm),
            self.locationIconImageView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.leadingAnchor)
        ])

        self.addSubview(self.currentLocationLabel)
        self.currentLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.currentLocationLabel.leadingAnchor.constraint(equalTo: self.locationIconImageView.trailingAnchor, constant: indicatorLabelLeadingAnchor),
            self.currentLocationLabel.centerYAnchor.constraint(equalTo: self.locationIconImageView.centerYAnchor)
        ])

        self.addSubview(self.busIconImageView)
        self.busIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busIconImageView.widthAnchor.constraint(equalToConstant: iconWidthAnchor),
            self.busIconImageView.heightAnchor.constraint(equalToConstant: iconHeightAnchor),
            self.busIconImageView.topAnchor.constraint(equalTo: self.locationIconImageView.bottomAnchor, constant: iconsVerticalTerm),
            self.busIconImageView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.leadingAnchor)
        ])

        self.addSubview(self.busNumberLabel)
        self.busNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busNumberLabel.leadingAnchor.constraint(equalTo: self.busIconImageView.trailingAnchor, constant: indicatorLabelLeadingAnchor),
            self.busNumberLabel.centerYAnchor.constraint(equalTo: self.busIconImageView.centerYAnchor)
        ])

        self.addSubview(self.alarmButton)
        self.alarmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmButton.widthAnchor.constraint(equalToConstant: alarmButtonWidthAnchor),
            self.alarmButton.heightAnchor.constraint(equalToConstant: alarmButtonHeightAnchor),
            self.alarmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.alarmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: alarmButtonTrailingAnchor)
        ])
    }

    func configure(busColor: UIColor) {
        self.busColorView.backgroundColor = busColor
    }

    func configure(order: String, remainingTime: String, remainingStationCount: String, busCongestionStatus: String, arrivalTime: String, currentLocation: String, busNumber: String) {
        self.busOrderNumberLabel.text = order
        self.remainingTimeLabel.text = remainingTime
        self.remainingStationCountLabel.text = remainingStationCount
        self.busCongestionStatusLabel.text = busCongestionStatus
        self.arrivalTimeLabel.text = arrivalTime
        self.currentLocationLabel.text = currentLocation
        self.busNumberLabel.text = busNumber
    }
}
