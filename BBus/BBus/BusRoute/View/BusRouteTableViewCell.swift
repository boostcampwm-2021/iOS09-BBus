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
        case .uturn:
            self.centerImageView.image = BBusImage.stationCenterUturn
            NSLayoutConstraint.activate([
                super.centerImageView.heightAnchor.constraint(equalToConstant: uturnImageHeight),
                super.centerImageView.widthAnchor.constraint(equalToConstant: uturnImageWidth),
                super.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                super.centerImageView.trailingAnchor.constraint(equalTo: super.beforeCongestionLineView.centerXAnchor, constant: uturmImageXaxisMargin)
            ])
        }
    }
    
    func configure(beforeColor: UIColor, afterColor: UIColor, title: String, description: String, type: BusRootCenterImageType) {
        super.configure(beforeColor: beforeColor,
                        afterColor: afterColor,
                        title: title,
                        description: description)
        
        self.configureCenterImage(type: type)
    }
}
