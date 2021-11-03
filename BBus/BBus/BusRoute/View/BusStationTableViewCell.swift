//
//  BusStationTableViewCell.swift
//  BBus
//
//  Created by 최수정 on 2021/11/02.
//

import UIKit

class BusStationTableViewCell: UITableViewCell {

    static let reusableID = "BusStationTableViewCell"
    static let cellHeight: CGFloat = 80

    private lazy var busRouteLineView = BusRouteLineView()
    
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
        self.addSubview(self.busRouteLineView)
        self.busRouteLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busRouteLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.busRouteLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.busRouteLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80)
        ])
        
        self.addSubview(self.stationTitleLabel)
        self.stationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            self.stationTitleLabel.leadingAnchor.constraint(equalTo: self.busRouteLineView.trailingAnchor, constant: 15),
            self.stationTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        self.addSubview(self.stationDescriptionLabel)
        self.stationDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationDescriptionLabel.topAnchor.constraint(equalTo: self.stationTitleLabel.bottomAnchor, constant: 5),
            self.stationDescriptionLabel.leadingAnchor.constraint(equalTo: self.stationTitleLabel.leadingAnchor),
            self.stationDescriptionLabel.trailingAnchor.constraint(equalTo: self.stationTitleLabel.trailingAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.stationTitleLabel.text = ""
        self.stationDescriptionLabel.text = ""
    }
    
    func configureLineColor(before: UIColor, after: UIColor) {
        self.busRouteLineView.configureLineColor(before: before, after: after)
    }
    
    func configureMockData() {
        self.stationTitleLabel.text = "면목동"
        self.stationDescriptionLabel.text = "19283 | 04:00-23:50"
    }
}
