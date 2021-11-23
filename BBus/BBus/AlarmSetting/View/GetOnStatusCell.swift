//
//  GetOnStatusCell.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/04.
//

import UIKit
import Combine

protocol GetOnAlarmButtonDelegate: AnyObject {
    func toggleGetOnAlarmSetting(for cell: UITableViewCell, cancel: Bool) -> Bool?
}

class GetOnStatusCell: UITableViewCell {

    static let reusableID = "GetOnStatusCell"
    static let infoCellHeight: CGFloat = 115
    static let singleInfoCellHeight: CGFloat = 50
    
    var cancellable: AnyCancellable?

    private lazy var busOrderNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 8
        let radius: CGFloat = 7.5

        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .bold)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = radius
        return label
    }()
    private lazy var remainingTimeLabel: UILabel = {
        let labelFontSize: CGFloat = 20

        let label = UILabel()
        label.textColor = BBusColor.black
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    private lazy var remainingStationCountLabel: UILabel = {
        let labelFontSize: CGFloat = 10

        let label = UILabel()
        label.textColor = BBusColor.bbusGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    private lazy var busCongestionStatusLabel: UILabel = {
        let labelFontSize: CGFloat = 10

        let label = UILabel()
        label.textColor = BBusColor.red
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
        stackView.layer.borderColor = BBusColor.bbusLightGray?.cgColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return stackView
    }()
    private lazy var clockIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = BBusImage.clockSymbol
        imageView.tintColor = BBusColor.iconColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var locationIconImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = BBusImage.locationSymbol
        imageView?.contentMode = .scaleAspectFit
        return imageview
    }()
    private lazy var busIconImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = BBusImage.busGraySymbol
        imageView?.contentMode = .scaleAspectFit
        return imageview
    }()
    private lazy var arrivalTimeLabel: UILabel = {
        let labelFontSize: CGFloat = 14

        let label = UILabel()
        label.textColor = BBusColor.systemGray
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .left
        return label
    }()
    private lazy var currentLocationLabel: UILabel = {
        let labelFontSize: CGFloat = 14

        let label = UILabel()
        label.textColor = BBusColor.systemGray
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .left
        return label
    }()
    private lazy var busNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 14

        let label = UILabel()
        label.textColor = BBusColor.systemGray
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.textAlignment = .left
        return label
    }()
    private lazy var alarmButton = AlarmSettingButton()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = BBusColor.bbusLightGray
        return view
    }()
    private lazy var noInfoMessageLabel: UILabel = {
        let labelFontSize: CGFloat = 20
        
        let label = UILabel()
        label.text = "도착 정보 없음"
        label.textColor = BBusColor.bbusGray
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        return label
    }()

    private weak var alarmButtonDelegate: GetOnAlarmButtonDelegate? {
        didSet {
            self.alarmButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                let result = self.alarmButtonDelegate?.toggleGetOnAlarmSetting(for: self, cancel: self.alarmButton.isSelected)
                if result == true {
                    self.alarmButton.isSelected.toggle()
                }
            }), for: .touchUpInside)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureLayout()
        self.backgroundColor = BBusColor.white
        self.selectionStyle = .none
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureLayout()
        self.backgroundColor = BBusColor.white
        self.selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cancellable?.cancel()
        self.configure(order: "",
                       remainingTime: nil,
                       remainingStationCount: nil,
                       busCongestionStatus: nil,
                       arrivalTime: nil,
                       currentLocation: "",
                       busNumber: "")
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

        self.addSubviews(self.busOrderNumberLabel, self.remainingTimeLabel, self.busStatusTagStackView, self.clockIconImageView, self.arrivalTimeLabel, self.locationIconImageView, self.currentLocationLabel, self.busIconImageView, self.busOrderNumberLabel, self.busNumberLabel, self.alarmButton, self.separatorView, self.noInfoMessageLabel)
        
        NSLayoutConstraint.activate([
            self.busOrderNumberLabel.widthAnchor.constraint(equalToConstant: busColorViewWidthAnchor),
            self.busOrderNumberLabel.heightAnchor.constraint(equalToConstant: busColorViewHeightAnchor),
            self.busOrderNumberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: busColorViewTopAnchor),
            self.busOrderNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: busColorViewLeadingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.remainingTimeLabel.centerYAnchor.constraint(equalTo: self.busOrderNumberLabel.centerYAnchor),
            self.remainingTimeLabel.leadingAnchor.constraint(equalTo: self.busOrderNumberLabel.trailingAnchor, constant: termBusColorViewToRemainingTimeLabel)
        ])

        NSLayoutConstraint.activate([
            self.busStatusTagStackView.centerYAnchor.constraint(equalTo: self.remainingTimeLabel.centerYAnchor),
            self.busStatusTagStackView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.trailingAnchor, constant: busStatusTagStackViewLeadingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.clockIconImageView.widthAnchor.constraint(equalToConstant: iconWidthAnchor),
            self.clockIconImageView.heightAnchor.constraint(equalToConstant: iconHeightAnchor),
            self.clockIconImageView.topAnchor.constraint(equalTo: self.remainingTimeLabel.bottomAnchor, constant: clockIconTopAnchor),
            self.clockIconImageView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.arrivalTimeLabel.leadingAnchor.constraint(equalTo: self.clockIconImageView.trailingAnchor, constant: indicatorLabelLeadingAnchor),
            self.arrivalTimeLabel.centerYAnchor.constraint(equalTo: self.clockIconImageView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            self.locationIconImageView.widthAnchor.constraint(equalToConstant: iconWidthAnchor),
            self.locationIconImageView.heightAnchor.constraint(equalToConstant: iconHeightAnchor),
            self.locationIconImageView.topAnchor.constraint(equalTo: self.clockIconImageView.bottomAnchor, constant: iconsVerticalTerm),
            self.locationIconImageView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.currentLocationLabel.leadingAnchor.constraint(equalTo: self.locationIconImageView.trailingAnchor, constant: indicatorLabelLeadingAnchor),
            self.currentLocationLabel.centerYAnchor.constraint(equalTo: self.locationIconImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.busIconImageView.widthAnchor.constraint(equalToConstant: iconWidthAnchor),
            self.busIconImageView.heightAnchor.constraint(equalToConstant: iconHeightAnchor),
            self.busIconImageView.topAnchor.constraint(equalTo: self.locationIconImageView.bottomAnchor, constant: iconsVerticalTerm),
            self.busIconImageView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            self.busNumberLabel.leadingAnchor.constraint(equalTo: self.busIconImageView.trailingAnchor, constant: indicatorLabelLeadingAnchor),
            self.busNumberLabel.centerYAnchor.constraint(equalTo: self.busIconImageView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            self.alarmButton.widthAnchor.constraint(equalToConstant: alarmButtonWidthAnchor),
            self.alarmButton.heightAnchor.constraint(equalToConstant: alarmButtonHeightAnchor),
            self.alarmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.alarmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: alarmButtonTrailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.separatorView.leadingAnchor.constraint(equalTo: self.remainingTimeLabel.leadingAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: separatorHeight),
            self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.noInfoMessageLabel.centerYAnchor.constraint(equalTo: self.busOrderNumberLabel.centerYAnchor),
            self.noInfoMessageLabel.leadingAnchor.constraint(equalTo: self.busOrderNumberLabel.trailingAnchor, constant: termBusColorViewToRemainingTimeLabel)
        ])
    }

    func configure(routeType: RouteType?) {
        switch routeType {
        case .mainLine:
            self.busOrderNumberLabel.backgroundColor = BBusColor.bbusTypeBlue
        case .broadArea:
            self.busOrderNumberLabel.backgroundColor = BBusColor.bbusTypeRed
        case .customized:
            self.busOrderNumberLabel.backgroundColor = BBusColor.bbusTypeGreen
        case .circulation:
            self.busOrderNumberLabel.backgroundColor = BBusColor.bbusTypeCirculation
        case .lateNight:
            self.busOrderNumberLabel.backgroundColor = BBusColor.bbusTypeBlue
        case .localLine:
            self.busOrderNumberLabel.backgroundColor = BBusColor.bbusTypeGreen
        default:
            self.busOrderNumberLabel.backgroundColor = BBusColor.bbusGray
        }
    }

    func configure(order: String, remainingTime: String?, remainingStationCount: String?, busCongestionStatus: String?, arrivalTime: String?, currentLocation: String, busNumber: String) {
        let isHidden = remainingTime == nil
        self.noInfoCellActivate(by: !isHidden)
        self.infoCellActivate(by: isHidden)
        self.busOrderNumberLabel.text = order
        
        if isHidden { return }
        self.remainingTimeLabel.text = remainingTime
        self.remainingStationCountLabel.text = remainingStationCount
        self.busCongestionStatusLabel.text = busCongestionStatus
        self.arrivalTimeLabel.text = arrivalTime
        self.currentLocationLabel.text = currentLocation
        self.busNumberLabel.text = busNumber
    }
    
    private func noInfoCellActivate(by isHidden: Bool) {
        self.noInfoMessageLabel.isHidden = isHidden
    }
    
    private func infoCellActivate(by isHidden: Bool) {
        self.remainingTimeLabel.isHidden = isHidden
        self.remainingStationCountLabel.isHidden = isHidden
        self.busCongestionStatusLabel.isHidden = isHidden
        self.arrivalTimeLabel.isHidden = isHidden
        self.currentLocationLabel.isHidden = isHidden
        self.busNumberLabel.isHidden = isHidden
        self.alarmButton.isHidden = isHidden
        self.locationIconImageView.isHidden = isHidden
        self.clockIconImageView.isHidden = isHidden
        self.busIconImageView.isHidden = isHidden
    }

    func configureDelegate(_ delegate: GetOnAlarmButtonDelegate) {
        self.alarmButtonDelegate = delegate
    }
}
