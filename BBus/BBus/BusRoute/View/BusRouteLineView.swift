//
//  BusRouteLineView.swift
//  BBus
//
//  Created by 최수정 on 2021/11/03.
//

import UIKit

class BusRouteLineView: UIView {
    
    private lazy var beforeLineView = UIView()
    
    private lazy var afterLineView = UIView()

    private lazy var centerPointImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = BusRouteViewController.Image.stationCenterCircle
        return imageView
    }()
    
    convenience init() {
        self.init(frame: CGRect())
        
        self.configureLayout()
    }

    private func configureLayout() {
        self.addSubview(self.centerPointImageView)
        self.centerPointImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerPointImageView.heightAnchor.constraint(equalToConstant: 15),
            self.centerPointImageView.widthAnchor.constraint(equalTo: self.centerPointImageView.heightAnchor),
            self.centerPointImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.centerPointImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.centerPointImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.insertSubview(self.beforeLineView, at: 0)
        self.beforeLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.beforeLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.beforeLineView.widthAnchor.constraint(equalToConstant: 3),
            self.beforeLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.beforeLineView.centerXAnchor.constraint(equalTo: self.centerPointImageView.centerXAnchor)
        ])
        
        self.insertSubview(self.afterLineView, at: 0)
        self.afterLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.afterLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.afterLineView.widthAnchor.constraint(equalToConstant: 3),
            self.afterLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.afterLineView.centerXAnchor.constraint(equalTo: self.centerPointImageView.centerXAnchor)
        ])
    }
    
    func configureLineColor(before: UIColor, after: UIColor) {
        self.beforeLineView.backgroundColor = before
        self.afterLineView.backgroundColor = after
    }
}
