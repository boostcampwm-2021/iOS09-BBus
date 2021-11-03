//
//  CustomNavigationBar.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/03.
//

import UIKit

protocol BackButtonDelegate: AnyObject {
    func touchedBackButton()
}

class CustomNavigationBar: UIView {

    lazy var customNavigationBarBackButton: UIButton = {
        let button = UIButton()
        button.tintColor = BusRouteViewController.Color.white
        button.setBackgroundImage(BusRouteViewController.Image.navigationBack, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchedBackButton), for: .touchUpInside)
        return button
    }()

    lazy var customNavigationBarBackButtonTitle: UILabel = {
        let label = UILabel()
        label.textColor = BusRouteViewController.Color.white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        return label
    }()

    lazy var customNavigationBarTitle: UILabel = {
        let label = UILabel()
        label.textColor = BusRouteViewController.Color.white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private var delegate: BackButtonDelegate?

    convenience init() {
        self.init(frame: CGRect())
        self.backgroundColor = BusRouteViewController.Color.blueBus
        self.configureLayout()
        self.configureMockNavigationData()
    }

    func configureLayout() {
        self.addSubview(self.customNavigationBarBackButton)
        self.customNavigationBarBackButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.customNavigationBarBackButton.widthAnchor.constraint(equalToConstant: 18),
            self.customNavigationBarBackButton.heightAnchor.constraint(equalToConstant: 27),
            self.customNavigationBarBackButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.customNavigationBarBackButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            self.customNavigationBarBackButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])

        self.addSubview(self.customNavigationBarBackButtonTitle)
        self.customNavigationBarBackButtonTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.customNavigationBarBackButtonTitle.centerYAnchor.constraint(equalTo: self.customNavigationBarBackButton.centerYAnchor),
            self.customNavigationBarBackButtonTitle.leadingAnchor.constraint(equalTo: self.customNavigationBarBackButton.trailingAnchor, constant: 12)
        ])

        self.addSubview(self.customNavigationBarTitle)
        self.customNavigationBarTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.customNavigationBarTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.customNavigationBarTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.customNavigationBarTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.customNavigationBarTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func configureDelegate(_ delegate: BackButtonDelegate) {
        self.delegate = delegate
    }

    @objc func touchedBackButton() {
        self.delegate?.touchedBackButton()
    }

    func configureMockNavigationData() {
        self.customNavigationBarBackButtonTitle.text = "641"
    }
}
