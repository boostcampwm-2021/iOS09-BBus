//
//  AlarmSettingTableViewCell.swift
//  BBus
//
//  Created by 최수정 on 2021/11/04.
//

import UIKit

protocol GetOffAlarmButtonDelegate {
    func shouldGoToMovingStatusScene()
}

class GetOffTableViewCell: BusStationTableViewCell {
    enum BusRootCenterImageType {
        case waypoint, getOn
    }
    
    static let reusableID = "GetOffTableViewCell"
    static let cellHeight: CGFloat = 80
    
    override var titleLeadingOffset: CGFloat { return 70 }
    override var lineTrailingOffset: CGFloat { return -35 }
    override var stationTitleLabelFontSize: CGFloat { return 15 }
    override var stationDescriptionLabelFontSize: CGFloat { return 12 }
    override var stackViewSpacing: CGFloat { return 4 }
    override var labelStackViewRightMargin: CGFloat { return -70 }
    
    private var alarmButtonDelegate: GetOffAlarmButtonDelegate? {
        didSet {
            self.alarmButton.addAction(UIAction(handler: { _ in
                self.alarmButtonDelegate?.shouldGoToMovingStatusScene()
            }), for: .touchUpInside)
        }
    }
    
    private lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(MyImage.alarm, for: .normal)
        button.tintColor = MyColor.bbusGray
        return button
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AlarmSettingViewController.Color.tableViewSeperator
        return view
    }()
    
    // MARK: - Configure
    override func configureLayout() {
        super.configureLayout()
        
        let alarmButtonWidthHeight: CGFloat = 20
        let alarmButtomRightMargin: CGFloat = -25
        let circleImageHeight: CGFloat = 15
        let circleImageWidth: CGFloat = 32
        let separatorHeight: CGFloat = 1
        
        self.contentView.addSubview(self.alarmButton)
        self.alarmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmButton.heightAnchor.constraint(equalToConstant: alarmButtonWidthHeight),
            self.alarmButton.widthAnchor.constraint(equalTo: self.alarmButton.heightAnchor),
            self.alarmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.alarmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: alarmButtomRightMargin)
        ])
        
        NSLayoutConstraint.activate([
            super.centerImageView.heightAnchor.constraint(equalToConstant: circleImageHeight),
            super.centerImageView.widthAnchor.constraint(equalToConstant: circleImageWidth),
            super.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            super.centerImageView.centerXAnchor.constraint(equalTo: super.beforeCongestionLineView.centerXAnchor)
        ])
        
        self.addSubview(self.separatorView)
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.separatorView.leadingAnchor.constraint(equalTo: super.labelStackView.leadingAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: separatorHeight),
            self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureCenterImage(type: BusRootCenterImageType) {
        switch type {
        case .waypoint:
            super.centerImageView.image = AlarmSettingViewController.Image.waypoint
        case .getOn:
            self.centerImageView.image = AlarmSettingViewController.Image.getOn
        }
    }
    
    func configure(beforeColor: UIColor, afterColor: UIColor, title: String, description: String, type: BusRootCenterImageType) {
        super.configure(beforeColor: beforeColor,
                        afterColor: afterColor,
                        title: title,
                        description: description)
        
        self.configureCenterImage(type: type)
    }
    
    func configureDelegate(_ delegate: GetOffAlarmButtonDelegate) {
        self.alarmButtonDelegate = delegate
    }
}
