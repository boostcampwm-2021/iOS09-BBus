//
//  BusRouteHeaderView.swift
//  BBus
//
//  Created by 최수정 on 2021/11/02.
//

import UIKit

class BusRouteHeaderView: UIView {

    private lazy var busTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var busNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var busFromStationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var busArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(systemName: "arrow.left.and.right")
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 15, height: 15))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.white
        return imageView
    }()
    
    private lazy var busToStationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var busStationIndicatorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.busFromStationLabel, self.busArrowImageView, self.busToStationLabel])
        stackView.axis = .horizontal
        stackView.spacing = 3
        return stackView
    }()

    convenience init() {
        self.init(frame: CGRect())
        self.backgroundColor = UIColor.systemBackground
        self.configureLayout()
        self.configureMockHeaderData()
    }
    
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
        
        self.addSubview(self.busStationIndicatorStackView)
        self.busStationIndicatorStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busStationIndicatorStackView.centerXAnchor.constraint(equalTo: self.busNumberLabel.centerXAnchor),
            self.busStationIndicatorStackView.topAnchor.constraint(equalTo: self.busNumberLabel.bottomAnchor, constant: 7)
        ])
    }
    
    func configureMockHeaderData() {
        self.busTypeLabel.text = "서울 간선버스"
        self.busNumberLabel.text = "272"
        self.busFromStationLabel.text = "면목동"
        self.busToStationLabel.text = "남가좌동"
    }
}
