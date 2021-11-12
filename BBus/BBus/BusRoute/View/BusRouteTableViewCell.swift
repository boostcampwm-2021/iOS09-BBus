//
//  BusRouteTableViewCell.swift
//  BBus
//
//  Created by 최수정 on 2021/11/04.
//

import UIKit

class BusRouteTableViewCell: BusStationTableViewCell {
    enum BusRootCenterImageType {
        case waypoint, uturn
    }

    static let reusableID = "BusRootTableViewCell"
    static let cellHeight: CGFloat = 80
    
    override var titleLeadingOffset: CGFloat { return 107 }
    override var lineTrailingOffset: CGFloat { return -20 }
    override var stationTitleLabelFontSize: CGFloat { return 17 }
    override var stationDescriptionLabelFontSize: CGFloat { return 14 }
    override var stackViewSpacing: CGFloat { return 5 }
    override var labelStackViewRightMargin: CGFloat { return -20 }
    
    private func configureCenterImage(type: BusRootCenterImageType) {
        let circleImageHeight: CGFloat = 15
        let circleImageWidth: CGFloat = 32
        let uturnImageHeight: CGFloat = 24
        let uturnImageWidth: CGFloat = 52
        let uturmImageXaxisMargin: CGFloat = 13
        
        switch type {
        case .waypoint:
            super.centerImageView.image = BBusImage.stationCenterCircle
            NSLayoutConstraint.activate([
                super.centerImageView.heightAnchor.constraint(equalToConstant: circleImageHeight),
                super.centerImageView.widthAnchor.constraint(equalToConstant: circleImageWidth),
                super.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                super.centerImageView.centerXAnchor.constraint(equalTo: super.beforeCongestionLineView.centerXAnchor)
            ])
            super.backgroundColor = BBusColor.bbusLightGray
        case .uturn:
            self.centerImageView.image = BBusImage.stationCenterUturn
            NSLayoutConstraint.activate([
                super.centerImageView.heightAnchor.constraint(equalToConstant: uturnImageHeight),
                super.centerImageView.widthAnchor.constraint(equalToConstant: uturnImageWidth),
                super.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                super.centerImageView.trailingAnchor.constraint(equalTo: super.beforeCongestionLineView.centerXAnchor, constant: uturmImageXaxisMargin)
            ])
            super.backgroundColor = BBusColor.white
        }
    }
    
    func configure(speed: Int, afterSpeed: Int?, index: Int, count: Int, title: String, description: String, type: BusRootCenterImageType) {
        let lineColors = self.configureLineColors(speed: speed,
                                                  afterSpeed: afterSpeed,
                                                 index: index,
                                                 count: count)
        super.configure(beforeColor: lineColors.beforeColor,
                        afterColor: lineColors.afterColor,
                        title: title,
                        description: description)
        
        self.configureCenterImage(type: type)
    }

    func configureLineColors(speed: Int, afterSpeed: Int?, index: Int, count: Int) -> (beforeColor:  UIColor?, afterColor:  UIColor?) {
        var beforeColor: UIColor?
        var afterColor: UIColor?
        if afterSpeed == nil {
            beforeColor = self.configureLineColor(speed: speed)
            afterColor = BBusColor.clear
        }
        else {
            guard let afterSpeed = afterSpeed else { return (UIColor(), UIColor())}
            if index == 0 {
                beforeColor = BBusColor.clear
                afterColor = self.configureLineColor(speed: afterSpeed)
            } else {
                beforeColor = self.configureLineColor(speed: speed)
                afterColor = self.configureLineColor(speed: afterSpeed)
            }
        }
        return (beforeColor, afterColor)
    }

    func configureLineColor(speed: Int) -> UIColor? {
        let color: UIColor?
        if speed <= 9 {
            color = BBusColor.bbusCongestionHigh
        }
        else if speed <= 20 {
            color = BBusColor.bbusCongestionNormal
        }
        else {
            color = BBusColor.bbusCongestionGood
        }
        return color
    }
}
