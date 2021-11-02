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

    private lazy var beforeLineView = UIView()
    private lazy var afterLineView = UIView()

    private lazy var centerPointImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StationCenterCircle")
        return imageView
    }()
    
    private lazy var stationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var stationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.systemGray
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

    func configureLayout() {
        self.addSubview(self.centerPointImageView)
        self.centerPointImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerPointImageView.heightAnchor.constraint(equalToConstant: 15),
            self.centerPointImageView.widthAnchor.constraint(equalTo: self.centerPointImageView.heightAnchor),
            self.centerPointImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 75),
            self.centerPointImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.insertSubview(self.beforeLineView, at: 0)
        self.beforeLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.beforeLineView.heightAnchor.constraint(equalToConstant: BusStationTableViewCell.cellHeight/2),
            self.beforeLineView.widthAnchor.constraint(equalToConstant: 3),
            self.beforeLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.beforeLineView.centerXAnchor.constraint(equalTo: self.centerPointImageView.centerXAnchor)
        ])
        
        self.insertSubview(self.afterLineView, at: 0)
        self.afterLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.afterLineView.heightAnchor.constraint(equalToConstant: BusStationTableViewCell.cellHeight/2),
            self.afterLineView.widthAnchor.constraint(equalToConstant: 3),
            self.afterLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.afterLineView.leadingAnchor.constraint(equalTo: self.beforeLineView.leadingAnchor)
        ])
        
        self.addSubview(self.stationTitleLabel)
        self.stationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            self.stationTitleLabel.leadingAnchor.constraint(equalTo: self.centerPointImageView.trailingAnchor, constant: 15),
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
        self.beforeLineView.backgroundColor = before
        self.afterLineView.backgroundColor = after
    }
    
    func configureMockData() {
        self.stationTitleLabel.text = "면목동"
        self.stationDescriptionLabel.text = "19283 | 04:00-23:50"
    }
}
