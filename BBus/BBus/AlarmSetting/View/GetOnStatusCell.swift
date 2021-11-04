//
//  GetOnStatusCell.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/04.
//

import UIKit

protocol GetOnAlarmButtonDelegate {
    func toggleGetOnAlarmSetting()
}

class GetOnStatusCell: UITableViewCell {

    static let reusableID = "GetOnStatusCell"
    static let cellHeight: CGFloat = 115

    private lazy var busOrderNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 8
        let radius: CGFloat = 7.5

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.white
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .bold)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = radius
        return label
    }()
    private lazy var remainingTimeLabel: UILabel = {
        let labelFontSize: CGFloat = 20

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.black
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .regular)
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
        stackView.layer.borderColor = AlarmSettingViewController.Color.tableViewSeperator.cgColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return stackView
    }()
    private lazy var clockIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AlarmSettingViewController.Image.clockIcon
        imageView.tintColor = AlarmSettingViewController.Color.iconColor
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
        let labelFontSize: CGFloat = 14

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.tableViewCellSubTitle
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .left
        return label
    }()
    private lazy var currentLocationLabel: UILabel = {
        let labelFontSize: CGFloat = 14

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.tableViewCellSubTitle
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .left
        return label
    }()
    private lazy var busNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 14

        let label = UILabel()
        label.textColor = AlarmSettingViewController.Color.tableViewCellSubTitle
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .left
        return label
    }()
    private lazy var alarmButton = AlarmSettingButton()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AlarmSettingViewController.Color.tableViewSeperator
        return view
    }()

    private var alarmButtonDelegate: GetOnAlarmButtonDelegate? {
        didSet {
            self.alarmButton.addAction(UIAction(handler: { _ in
                self.alarmButton.isSelected.toggle()
                self.alarmButtonDelegate?.toggleGetOnAlarmSetting()
            }), for: .touchUpInside)
        }
    }

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
        
        self.alarmButton.removeTarget(nil, action: nil, for: .allEvents)
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
        let iconsVerticalTerm: CGFloat = 6.5
        let iconWidthAnchor: CGFloat = 15
        let iconHeightAnchor: CGFloat = 15
        let alarmButtonWidthAnchor: CGFloat = 40
        let alarmButtonHeightAnchor: CGFloat = 40
        let alarmButtonTrailingAnchor: CGFloat = -15
        let indicatorLabelLeadingAnchor: CGFloat = 5
        let separatorHeight: CGFloat = 1

        self.addSubview(self.busOrderNumberLabel)
        self.busOrderNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busOrderNumberLabel.widthAnchor.constraint(equalToConstant: busColorViewWidthAnchor),
            self.busOrderNumberLabel.heightAnchor.constraint(equalToConstant: busColorViewHeightAnchor),
            self.busOrderNumberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: busColorViewTopAnchor),
            self.busOrderNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: busColorViewLeadingAnchor)
        ])

        self.addSubview(self.remainingTimeLabel)
        self.remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.remainingTimeLabel.centerYAnchor.constraint(equalTo: self.busOrderNumberLabel.centerYAnchor),
            self.remainingTimeLabel.leadingAnchor.constraint(equalTo: self.busOrderNumberLabel.trailingAnchor, constant: termBusColorViewToRemainingTimeLabel)
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
        
        self.addSubview(self.separatorView)
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.separatorView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.leadingAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: separatorHeight),
            self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func configure(busColor: UIColor) {
        self.busOrderNumberLabel.backgroundColor = busColor
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

    func configureDelegate(_ delegate: GetOnAlarmButtonDelegate) {
        self.alarmButtonDelegate = delegate
    }
}
