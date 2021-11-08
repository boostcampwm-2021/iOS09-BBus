//
//  MovingStatusTableViewCell.swift
//  BBus
//
//  Created by 최수정 on 2021/11/05.
//

import UIKit

class MovingStatusTableViewCell: BusStationTableViewCell {

    enum BusRouteCenterImageType {
        case waypoint, getOn, getOff
    }
    
    static let reusableID = "MovingStatusTableViewCell"
    static let cellHeight: CGFloat = 80
    
    override var titleLeadingOffset: CGFloat { return 135 }
    override var lineTrailingOffset: CGFloat { return -25 }
    override var stationTitleLabelFontSize: CGFloat { return 15 }
    override var labelStackViewRightMargin: CGFloat { return -30 }

    // MARK: - Configure
    override func configureLayout() {
        super.configureLayout()
        
        let circleImageHeight: CGFloat = 15
        let circleImageWidth: CGFloat = 32
        
        NSLayoutConstraint.activate([
            super.centerImageView.heightAnchor.constraint(equalToConstant: circleImageHeight),
            super.centerImageView.widthAnchor.constraint(equalToConstant: circleImageWidth),
            super.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            super.centerImageView.centerXAnchor.constraint(equalTo: super.beforeCongestionLineView.centerXAnchor)
        ])
    }
    
    private func configureCenterImage(type: BusRouteCenterImageType) {
        switch type {
        case .waypoint:
            super.centerImageView.image = MovingStatusViewController.Image.waypoint
        case .getOn:
            super.centerImageView.image = MovingStatusViewController.Image.getOn
        case .getOff:
            super.centerImageView.image = MovingStatusViewController.Image.getOff
        }
    }
    
    func configure(type: BusRouteCenterImageType) {
        self.configureCenterImage(type: type)
        switch type {
        case .getOn:
            super.configure(beforeColor: MovingStatusViewController.Color.clear,
                            afterColor: MovingStatusViewController.Color.congestionLine,
                            title: "웨딩타운",
                            description: "")
        case .waypoint:
            super.configure(beforeColor: MovingStatusViewController.Color.congestionLine,
                            afterColor: MovingStatusViewController.Color.congestionLine,
                            title: "웨딩타운",
                            description: "")
        case .getOff:
            super.configure(beforeColor: MovingStatusViewController.Color.congestionLine,
                            afterColor: MovingStatusViewController.Color.clear,
                            title: "웨딩타운",
                            description: "")
        }
    }
}
