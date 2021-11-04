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
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    private lazy var stationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
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
        self.addSubview(self.stationTitleLabel)
        self.stationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            self.stationTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.titleLeadingOffset),
            self.stationTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        self.addSubview(self.stationDescriptionLabel)
        self.stationDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationDescriptionLabel.topAnchor.constraint(equalTo: self.stationTitleLabel.bottomAnchor, constant: 5),
            self.stationDescriptionLabel.leadingAnchor.constraint(equalTo: self.stationTitleLabel.leadingAnchor),
            self.stationDescriptionLabel.trailingAnchor.constraint(equalTo: self.stationTitleLabel.trailingAnchor)
        ])
        
        self.addSubview(self.beforeCongestionLineView)
        self.beforeCongestionLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.beforeCongestionLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.beforeCongestionLineView.widthAnchor.constraint(equalToConstant: 3),
            self.beforeCongestionLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.beforeCongestionLineView.centerXAnchor.constraint(equalTo: self.stationTitleLabel.leadingAnchor, constant: self.lineTrailingOffset)
        ])
        
        self.addSubview(self.afterCongestionLineView)
        self.afterCongestionLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.afterCongestionLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.afterCongestionLineView.widthAnchor.constraint(equalToConstant: 3),
            self.afterCongestionLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.afterCongestionLineView.centerXAnchor.constraint(equalTo: self.beforeCongestionLineView.centerXAnchor)
        ])
        
        self.addSubview(self.centerImageView)
        self.centerImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCenterImage(type: BusRootCenterImageType) {
        switch type {
        case .waypoint:
            self.centerImageView.image = BusRouteViewController.Image.stationCenterCircle
            NSLayoutConstraint.activate([
                self.centerImageView.heightAnchor.constraint(equalToConstant: 15),
                self.centerImageView.widthAnchor.constraint(equalToConstant: 32),
                self.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.centerImageView.centerXAnchor.constraint(equalTo: self.beforeCongestionLineView.centerXAnchor)
            ])
        case .uturn:
            self.centerImageView.image = BusRouteViewController.Image.stationCenterUturn
            NSLayoutConstraint.activate([
                self.centerImageView.heightAnchor.constraint(equalToConstant: 24),
                self.centerImageView.widthAnchor.constraint(equalToConstant: 52),
                self.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.centerImageView.trailingAnchor.constraint(equalTo: self.beforeCongestionLineView.centerXAnchor, constant: 13)
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
