//
//  BusRouteHeaderView.swift
//  BBus
//
//  Created by 최수정 on 2021/11/02.
//

import UIKit

class BusRouteHeaderView: UIView {

    static let headerHeight: CGFloat = 170

    private lazy var busTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = BusRouteViewController.Color.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    private lazy var busNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = BusRouteViewController.Color.white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    private lazy var busFromStationLabel: UILabel = {
        let label = UILabel()
        label.textColor = BusRouteViewController.Color.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    private lazy var busArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = BusRouteViewController.Image.headerArrow
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 15, height: 15))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = BusRouteViewController.Color.white
        return imageView
    }()
    private lazy var busToStationLabel: UILabel = {
        let label = UILabel()
        label.textColor = BusRouteViewController.Color.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    private lazy var busStationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.busFromStationLabel, self.busArrowImageView, self.busToStationLabel])
        stackView.axis = .horizontal
        stackView.spacing = 3
        return stackView
    }()

    convenience init() {
        self.init(frame: CGRect())

        self.configureLayout()
    }

    // MARK: - Configure
    func configureLayout() {
        self.addSubview(self.busNumberLabel)
        self.busNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busNumberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.busNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10)
        ])
        
        self.addSubview(self.busTypeLabel)
        self.busTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busTypeLabel.centerXAnchor.constraint(equalTo: self.busNumberLabel.centerXAnchor),
            self.busTypeLabel.bottomAnchor.constraint(equalTo: self.busNumberLabel.topAnchor, constant: -5)
        ])
        
        self.addSubview(self.busStationStackView)
        self.busStationStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busStationStackView.centerXAnchor.constraint(equalTo: self.busNumberLabel.centerXAnchor),
            self.busStationStackView.topAnchor.constraint(equalTo: self.busNumberLabel.bottomAnchor, constant: 7)
        ])
    }

    func configure(busType: String, busNumber: String, fromStation: String, toStation: String) {
        self.busTypeLabel.text = busType
        self.busNumberLabel.text = busNumber
        self.busFromStationLabel.text = fromStation
        self.busToStationLabel.text = toStation
    }
}
