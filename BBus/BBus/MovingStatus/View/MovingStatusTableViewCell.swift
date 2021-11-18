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
            super.centerImageView.image = BBusImage.waypoint
        case .getOn:
            super.centerImageView.image = BBusImage.getOn
        case .getOff:
            super.centerImageView.image = BBusImage.getOff
        }
    }
    
    func configure(speed: Int, afterSpeed: Int?, index: Int, count: Int, title: String) {
        let lineColors = self.configureLineColors(currentSpeed: speed,
                                                  afterSpeed: afterSpeed,
                                                  index: index,
                                                  count: count)
        super.configure(beforeColor: lineColors.beforeColor,
                        afterColor: lineColors.afterColor,
                        title: title,
                        description: "")
        
        let type: BusRouteCenterImageType

        if index == 0 {
            type = .getOn
        } else if index == count-1 {
            type = .getOff
        } else {
            type = .waypoint
        }

        self.configureCenterImage(type: type)
    }

    func configureLineColors(currentSpeed: Int, afterSpeed: Int?, index: Int, count: Int) -> (beforeColor:  UIColor?, afterColor:  UIColor?) {
        var beforeColor: UIColor?
        var afterColor: UIColor?
        if index == count-1 {
            beforeColor = self.configureLineColor(speed: currentSpeed)
            afterColor = BBusColor.clear
        }
        else {
            guard let afterSpeed = afterSpeed else { return (nil, nil)}
            if index == 0 {
                beforeColor = BBusColor.clear
                afterColor = self.configureLineColor(speed: afterSpeed)
            } else {
                beforeColor = self.configureLineColor(speed: currentSpeed)
                afterColor = self.configureLineColor(speed: afterSpeed)
            }
        }

        return (beforeColor, afterColor)
    }

    func configureLineColor(speed: Int) -> UIColor? {
        let maxHeightCongestionSpped = 9
        let maxNormalCongestionSpeed = 20
        let color: UIColor?

        if speed <= maxHeightCongestionSpped {
            color = BBusColor.bbusCongestionHigh
        }
        else if speed <= maxNormalCongestionSpeed {
            color = BBusColor.bbusCongestionMedium
        }
        else {
            color = BBusColor.bbusCongestionLow
        }
        return color
    }
}
