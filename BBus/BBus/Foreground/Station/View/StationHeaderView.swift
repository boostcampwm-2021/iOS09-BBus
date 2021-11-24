//
//  StationHeaderView.swift
//  BBus
//
//  Created by 최수정 on 2021/11/02.
//

import UIKit

class StationHeaderView: UIView {

    static let headerHeight: CGFloat = 170

    private lazy var stationIdLabel: UILabel = {
        let typeLabelFontSize: CGFloat = 15

        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: typeLabelFontSize)
        label.textAlignment = .center
        return label
    }()
    private lazy var stationNameLabel: UILabel = {
        let numberLabelFontSize: CGFloat = 22

        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.boldSystemFont(ofSize: numberLabelFontSize)
        label.textAlignment = .center
        return label
    }()
    private lazy var directionLabel: UILabel = {
        let fromStationLabelFontSize: CGFloat = 15

        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: fromStationLabelFontSize)
        label.textAlignment = .center
        return label
    }()

    convenience init() {
        self.init(frame: CGRect())

        self.configureLayout()
    }

    // MARK: - Configure
    func configureLayout() {
        let stationIdLabelYaxisMargin: CGFloat = 10
        let stationIdLabelBottomMargin: CGFloat = -5
        let directionLabelTopMargin: CGFloat = 7
        
        self.addSubviews(self.stationNameLabel, self.stationIdLabel, self.directionLabel)

        NSLayoutConstraint.activate([
            self.stationNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stationNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: stationIdLabelYaxisMargin)
        ])

        NSLayoutConstraint.activate([
            self.stationIdLabel.centerXAnchor.constraint(equalTo: self.stationNameLabel.centerXAnchor),
            self.stationIdLabel.bottomAnchor.constraint(equalTo: self.stationNameLabel.topAnchor, constant: stationIdLabelBottomMargin)
        ])

        NSLayoutConstraint.activate([
            self.directionLabel.centerXAnchor.constraint(equalTo: self.stationNameLabel.centerXAnchor),
            self.directionLabel.topAnchor.constraint(equalTo: self.stationNameLabel.bottomAnchor, constant: directionLabelTopMargin)
        ])
    }

    func configureStationInfo(stationId: String, stationName: String) {
        self.stationIdLabel.text = stationId
        self.stationNameLabel.text = stationName
    }
    
    func configure(nextStationName: String) {
        let suffix = "방면"
        self.directionLabel.text = "\(nextStationName) \(suffix)"
    }
}
