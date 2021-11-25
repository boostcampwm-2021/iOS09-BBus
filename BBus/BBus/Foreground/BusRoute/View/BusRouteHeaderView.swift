//
//  BusRouteHeaderView.swift
//  BBus
//
//  Created by 최수정 on 2021/11/02.
//

import UIKit

final class BusRouteHeaderView: UIView {

    static let headerHeight: CGFloat = 170

    private lazy var busTypeLabel: UILabel = {
        let typeLabelFontSize: CGFloat = 15
        
        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: typeLabelFontSize)
        label.textAlignment = .center
        return label
    }()
    private lazy var busNumberLabel: UILabel = {
        let numberLabelFontSize: CGFloat = 22
        
        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.boldSystemFont(ofSize: numberLabelFontSize)
        label.textAlignment = .center
        return label
    }()
    private lazy var busFromStationLabel: UILabel = {
        let fromStationLabelFontSize: CGFloat = 15
        
        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: fromStationLabelFontSize)
        label.textAlignment = .center
        return label
    }()
    private lazy var busArrowImageView: UIImageView = {
        let busArrowImageWidthHeight: CGFloat = 15
        
        let imageView = UIImageView()
        imageView.image = BBusImage.headerArrow
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: busArrowImageWidthHeight, height: busArrowImageWidthHeight))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = BBusColor.white
        return imageView
    }()
    private lazy var busToStationLabel: UILabel = {
        let toStationLabelFontSize: CGFloat = 15
        
        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: toStationLabelFontSize)
        label.textAlignment = .center
        return label
    }()
    private lazy var busStationStackView: UIStackView = {
        let stackViewSpacing: CGFloat = 3
        
        let stackView = UIStackView(arrangedSubviews: [self.busFromStationLabel, self.busArrowImageView, self.busToStationLabel])
        stackView.axis = .horizontal
        stackView.spacing = stackViewSpacing
        return stackView
    }()

    convenience init() {
        self.init(frame: CGRect())

        self.configureLayout()
    }

    // MARK: - Configure
    func configureLayout() {
        let busNumberLabelYaxisMargin: CGFloat = 10
        let busTypeLabelBottomMargin: CGFloat = -5
        let stackViewTopMargin: CGFloat = 7
        
        self.addSubviews(self.busNumberLabel, self.busTypeLabel, self.busStationStackView)
        
        NSLayoutConstraint.activate([
            self.busNumberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.busNumberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: busNumberLabelYaxisMargin)
        ])
        
        NSLayoutConstraint.activate([
            self.busTypeLabel.centerXAnchor.constraint(equalTo: self.busNumberLabel.centerXAnchor),
            self.busTypeLabel.bottomAnchor.constraint(equalTo: self.busNumberLabel.topAnchor, constant: busTypeLabelBottomMargin)
        ])
        
        NSLayoutConstraint.activate([
            self.busStationStackView.centerXAnchor.constraint(equalTo: self.busNumberLabel.centerXAnchor),
            self.busStationStackView.topAnchor.constraint(equalTo: self.busNumberLabel.bottomAnchor, constant: stackViewTopMargin)
        ])
    }

    func configure(busType: String, busNumber: String, fromStation: String, toStation: String) {
        self.busTypeLabel.text = busType
        self.busNumberLabel.text = busNumber
        self.busFromStationLabel.text = fromStation
        self.busToStationLabel.text = toStation
    }
}
