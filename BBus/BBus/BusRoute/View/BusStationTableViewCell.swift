//
//  BusStationTableViewCell.swift
//  BBus
//
//  Created by 최수정 on 2021/11/02.
//

import UIKit

class BusStationTableViewCell: UITableViewCell {
    
    enum CenterImageType {
        case circle, uturn, getOn, getOff
    }

    static let reusableID = "BusStationTableViewCell"
    static let cellHeight: CGFloat = 80
    
    var titleLeadingOffset: CGFloat { return 107 }
    var lineTrailingOffset: CGFloat { return -20 }
    
    private lazy var beforeLineView = UIView()
    private lazy var afterLineView = UIView()
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

    private func configureLayout() {
        self.addSubview(self.stationTitleLabel)
        self.stationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            self.stationTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: titleLeadingOffset),
            self.stationTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        self.addSubview(self.stationDescriptionLabel)
        self.stationDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationDescriptionLabel.topAnchor.constraint(equalTo: self.stationTitleLabel.bottomAnchor, constant: 5),
            self.stationDescriptionLabel.leadingAnchor.constraint(equalTo: self.stationTitleLabel.leadingAnchor),
            self.stationDescriptionLabel.trailingAnchor.constraint(equalTo: self.stationTitleLabel.trailingAnchor)
        ])
        
        self.addSubview(self.beforeLineView)
        self.beforeLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.beforeLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.beforeLineView.widthAnchor.constraint(equalToConstant: 3),
            self.beforeLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.beforeLineView.centerXAnchor.constraint(equalTo: self.stationTitleLabel.leadingAnchor, constant: lineTrailingOffset)
        ])
        
        self.addSubview(self.afterLineView)
        self.afterLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.afterLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.afterLineView.widthAnchor.constraint(equalToConstant: 3),
            self.afterLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.afterLineView.centerXAnchor.constraint(equalTo: self.beforeLineView.centerXAnchor)
        ])
        
        self.addSubview(centerImageView)
        self.centerImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.stationTitleLabel.text = ""
        self.stationDescriptionLabel.text = ""
    }
    
    func configureCenterImage(type: CenterImageType) {
        switch type {
        case .circle:
            self.centerImageView.image = BusRouteViewController.Image.stationCenterCircle
            NSLayoutConstraint.activate([
                self.centerImageView.heightAnchor.constraint(equalToConstant: 15),
                self.centerImageView.widthAnchor.constraint(equalToConstant: 32),
                self.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.centerImageView.centerXAnchor.constraint(equalTo: self.beforeLineView.centerXAnchor)
            ])
        case .uturn:
            self.centerImageView.image = BusRouteViewController.Image.stationCenterUturn
            NSLayoutConstraint.activate([
                self.centerImageView.heightAnchor.constraint(equalToConstant: 24),
                self.centerImageView.widthAnchor.constraint(equalToConstant: 52),
                self.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.centerImageView.trailingAnchor.constraint(equalTo: self.beforeLineView.centerXAnchor, constant: 13)
            ])
        case .getOn:
            return
        case .getOff:
            return
        }
    }
    
    func configureLineColor(before: UIColor, after: UIColor) {
        self.beforeLineView.backgroundColor = before
        self.afterLineView.backgroundColor = after
    }
    
    func configureMockData() {
        self.stationTitleLabel.text = "면목동"
        self.stationDescriptionLabel.text = "19283 | 04:00-23:50"
    }
}
