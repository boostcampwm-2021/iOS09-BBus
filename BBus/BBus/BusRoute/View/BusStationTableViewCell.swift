//
//  BusStationTableViewCell.swift
//  BBus
//
//  Created by 최수정 on 2021/11/02.
//

import UIKit

class BusStationTableViewCell: UITableViewCell {
    
    enum BusRootCenterImageType {
        case waypoint, uturn
    }

    static let reusableID = "BusStationTableViewCell"
    static let cellHeight: CGFloat = 80
    
    var titleLeadingOffset: CGFloat { return 107 }
    var lineTrailingOffset: CGFloat { return -20 }
    
    private lazy var beforeCongestionLineView = UIView()
    private lazy var afterCongestionLineView = UIView()
    private lazy var centerImageView = UIImageView()
    private lazy var stationTitleLabel: UILabel = {
        let stationTitleLabelFontSize: CGFloat = 17
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: stationTitleLabelFontSize, weight: .semibold)
        return label
    }()
    private lazy var stationDescriptionLabel: UILabel = {
        let stationDescriptionLabelFontSize: CGFloat = 14
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: stationDescriptionLabelFontSize)
        label.textColor = BusRouteViewController.Color.tableViewCellSubTitle
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureLayout()
        self.selectionStyle = .none
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureLayout()
        self.selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.stationTitleLabel.text = ""
        self.stationDescriptionLabel.text = ""
    }

    // MARK: - Configure
    private func configureLayout() {
        let stationTitleLabelTopMargin: CGFloat = 18
        let stationTitleLabelRightMargin: CGFloat = -20
        let stationDescriptionLabelTopMargin: CGFloat = 5
        let congestionLineViewHeightMultiplier: CGFloat = 0.5
        let congestionLineViewWidth: CGFloat = 3
        
        self.addSubview(self.stationTitleLabel)
        self.stationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: stationTitleLabelTopMargin),
            self.stationTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.titleLeadingOffset),
            self.stationTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: stationTitleLabelRightMargin)
        ])
        
        self.addSubview(self.stationDescriptionLabel)
        self.stationDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationDescriptionLabel.topAnchor.constraint(equalTo: self.stationTitleLabel.bottomAnchor, constant: stationDescriptionLabelTopMargin),
            self.stationDescriptionLabel.leadingAnchor.constraint(equalTo: self.stationTitleLabel.leadingAnchor),
            self.stationDescriptionLabel.trailingAnchor.constraint(equalTo: self.stationTitleLabel.trailingAnchor)
        ])
        
        self.addSubview(self.beforeCongestionLineView)
        self.beforeCongestionLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.beforeCongestionLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: congestionLineViewHeightMultiplier),
            self.beforeCongestionLineView.widthAnchor.constraint(equalToConstant: congestionLineViewWidth),
            self.beforeCongestionLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.beforeCongestionLineView.centerXAnchor.constraint(equalTo: self.stationTitleLabel.leadingAnchor, constant: self.lineTrailingOffset)
        ])
        
        self.addSubview(self.afterCongestionLineView)
        self.afterCongestionLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.afterCongestionLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: congestionLineViewHeightMultiplier),
            self.afterCongestionLineView.widthAnchor.constraint(equalToConstant: congestionLineViewWidth),
            self.afterCongestionLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.afterCongestionLineView.centerXAnchor.constraint(equalTo: self.beforeCongestionLineView.centerXAnchor)
        ])
        
        self.addSubview(self.centerImageView)
        self.centerImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCenterImage(type: BusRootCenterImageType) {
        let circleImageHeight: CGFloat = 15
        let circleImageWidth: CGFloat = 32
        let uturnImageHeight: CGFloat = 24
        let uturnImageWidth: CGFloat = 52
        let uturmImageXaxisMargin: CGFloat = 13
        
        switch type {
        case .waypoint:
            self.centerImageView.image = BusRouteViewController.Image.stationCenterCircle
            NSLayoutConstraint.activate([
                self.centerImageView.heightAnchor.constraint(equalToConstant: circleImageHeight),
                self.centerImageView.widthAnchor.constraint(equalToConstant: circleImageWidth),
                self.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.centerImageView.centerXAnchor.constraint(equalTo: self.beforeCongestionLineView.centerXAnchor)
            ])
        case .uturn:
            self.centerImageView.image = BusRouteViewController.Image.stationCenterUturn
            NSLayoutConstraint.activate([
                self.centerImageView.heightAnchor.constraint(equalToConstant: uturnImageHeight),
                self.centerImageView.widthAnchor.constraint(equalToConstant: uturnImageWidth),
                self.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.centerImageView.trailingAnchor.constraint(equalTo: self.beforeCongestionLineView.centerXAnchor, constant: uturmImageXaxisMargin)
            ])
        }
    }

    func configure(beforeColor: UIColor, afterColor: UIColor, title: String, description: String, type: BusRootCenterImageType) {
        self.beforeCongestionLineView.backgroundColor = beforeColor
        self.afterCongestionLineView.backgroundColor = afterColor
        self.stationTitleLabel.text = title
        self.stationDescriptionLabel.text = description
        self.configureCenterImage(type: type)
    }
}
