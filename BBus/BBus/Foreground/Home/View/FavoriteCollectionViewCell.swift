//
//  FavoriteCollectionViewCell.swift
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
            self.trailingView.alarmButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                
                self.alarmButtonDelegate?.shouldGoToAlarmSettingScene(at: self)
            }), for: .touchUpInside)

        }
    }
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = BBusColor.gray
        return loader
    }()
    class var height: CGFloat { return 70 }
    static let identifier = "FavoriteCollectionViewCell"
    var busNumberYAxisMargin: CGFloat { return 0 }
    var busNumberFontSize: CGFloat { return 22 }
    var busNumberLeadingInterval: CGFloat { return 20 }

    private lazy var busNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: self.busNumberFontSize)
        label.textColor = BBusColor.bbusTypeBlue
        return label
    }()
    private lazy var trailingView = BusCellTrailingView()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cancellables.removeAll()
        self.loader.isHidden = false
        self.loader.startAnimating()
        self.busNumberLabel.text = ""
        self.trailingView.configure(firstBusTime: nil,
                                    firstBusRemaining: nil,
                                    firstBusCongestion: nil,
                                    secondBusTime: nil,
                                    secondBusRemaining: nil,
                                    secondBusCongestion: nil)
        self.trailingView.configure(alarmButtonActive: false)
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
     func configureLayout() {
        let half: CGFloat = 0.5
         
         self.addSubviews(self.busNumberLabel, self.trailingView, self.loader)

         
        let busNumberLeadingConstraint = self.busNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.busNumberLeadingInterval)
        busNumberLeadingConstraint.priority = UILayoutPriority.defaultHigh
        NSLayoutConstraint.activate([
            self.busNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: self.busNumberYAxisMargin),
            busNumberLeadingConstraint
        ])

        NSLayoutConstraint.activate([
            self.trailingView.topAnchor.constraint(equalTo: self.topAnchor),
            self.trailingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.trailingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.trailingView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: half)
        ])

         NSLayoutConstraint.activate([
            self.loader.topAnchor.constraint(equalTo: self.topAnchor),
            self.loader.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.loader.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.loader.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: half)
         ])
    }

    func configureDelegate(_ delegate: AlarmButtonDelegate) {
        self.alarmButtonDelegate = delegate
    }

    private func configureUI() {
        self.backgroundColor = BBusColor.white
    }
    
    func configure(busNumber: String, routeType: RouteType?, firstBusTime: String?, firstBusRelativePosition: String?, firstBusCongestion: String?, secondBusTime: String?, secondBusRelativePosition: String?, secondBusCongestion: String?) {
        self.busNumberLabel.text = busNumber

        self.loader.isHidden = true
        self.loader.stopAnimating()
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
                                    secondBusCongestion: secondBusCongestion)
    }

    func configure(alarmButtonActive: Bool) {
        self.trailingView.configure(alarmButtonActive: alarmButtonActive)
    }
}
