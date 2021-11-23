//
//  FavoriteTableViewCell.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/02.
//

import UIKit
import Combine

class FavoriteCollectionViewCell: UICollectionViewCell {

    var cancellables = Set<AnyCancellable>()
    private weak var alarmButtonDelegate: AlarmButtonDelegate? {
        didSet {
            self.trailingView.alarmButton.removeTarget(nil, action: nil, for: .allEvents)
            self.trailingView.alarmButton.addAction(UIAction(handler: { _ in
                self.alarmButtonDelegate?.shouldGoToAlarmSettingScene(at: self)
            }), for: .touchUpInside)

        }
    }
    class var height: CGFloat { return 70 }
    static let identifier = "FavoriteCollectionViewCell"
    var busNumberYAxisMargin: CGFloat { return 0 }
    var busNumberFontSize: CGFloat { return 22 }
    var busNumberLeadingInterval: CGFloat { return 20 }

    private lazy var busNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "272"
        label.font = UIFont.boldSystemFont(ofSize: self.busNumberFontSize)
        label.textColor = BBusColor.bbusTypeBlue
        return label
    }()
    private lazy var trailingView = BusCellTrailingView()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
        self.busNumberLabel.text = ""
        self.trailingView.configure(firstBusTime: nil,
                                    firstBusRemaining: nil,
                                    firstBusCongestion: nil,
                                    secondBusTime: nil,
                                    secondBusRemaining: nil,
                                    secondBusCongestion: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.trailingView.configureLayout()
        self.configureLayout()
        self.configureUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.trailingView.configureLayout()
        self.configureLayout()
        self.configureUI()
    }

    // MARK: - Configuration
    // Only uses Subclass
     func configureLayout() {
        let half: CGFloat = 0.5

        self.addSubview(self.busNumberLabel)
        let busNumberLeadingConstraint = self.busNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.busNumberLeadingInterval)
        busNumberLeadingConstraint.priority = UILayoutPriority.defaultHigh
        self.busNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: self.busNumberYAxisMargin),
            busNumberLeadingConstraint
        ])

        self.addSubview(self.trailingView)
        self.trailingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.trailingView.topAnchor.constraint(equalTo: self.topAnchor),
            self.trailingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.trailingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.trailingView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: half)
        ])
    }

    func configureDelegate(_ delegate: AlarmButtonDelegate) {
        self.alarmButtonDelegate = delegate
    }

    private func configureUI() {
        self.backgroundColor = BBusColor.white
    }
    
    func configure(busNumber: String, routeType: RouteType?, firstBusTime: String?, firstBusRelativePosition: String?, firstBusCongestion: String?, secondBusTime: String?, secondBusRelativePosition: String?, secondBusCongsetion: String?) {
        self.busNumberLabel.text = busNumber

        switch routeType {
        case .mainLine:
            self.busNumberLabel.textColor = BBusColor.bbusTypeBlue
        case .broadArea:
            self.busNumberLabel.textColor = BBusColor.bbusTypeRed
        case .customized:
            self.busNumberLabel.textColor = BBusColor.bbusTypeGreen
        case .circulation:
            self.busNumberLabel.textColor = BBusColor.bbusTypeCirculation
        case .lateNight:
            self.busNumberLabel.textColor = BBusColor.bbusTypeBlue
        case .localLine:
            self.busNumberLabel.textColor = BBusColor.bbusTypeGreen
        default:
            self.busNumberLabel.textColor = BBusColor.bbusGray
        }
        self.trailingView.configure(firstBusTime: firstBusTime,
                                    firstBusRemaining: firstBusRelativePosition,
                                    firstBusCongestion: firstBusCongestion,
                                    secondBusTime: secondBusTime,
                                    secondBusRemaining: secondBusRelativePosition,
                                    secondBusCongestion: secondBusCongsetion)
    }
}
