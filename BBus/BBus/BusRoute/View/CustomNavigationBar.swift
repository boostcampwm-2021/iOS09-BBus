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

    private var delegate: BackButtonDelegate? {
        didSet {
            self.backButton.addAction(UIAction(handler: { _ in
                self.delegate?.touchedBackButton()
            }), for: .touchUpInside)
        }
    }

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.tintColor = BusRouteViewController.Color.white
        button.setBackgroundImage(BusRouteViewController.Image.navigationBack, for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    private lazy var backButtonTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = BusRouteViewController.Color.white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = BusRouteViewController.Color.white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    convenience init() {
        self.init(frame: CGRect())

        self.configureLayout()
    }

    // MARK: - Configure
    func configureLayout() {
        self.addSubview(self.backButton)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.backButton.widthAnchor.constraint(equalToConstant: 18),
            self.backButton.heightAnchor.constraint(equalToConstant: 27),
            self.backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            self.backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])

        self.addSubview(self.backButtonTitleLabel)
        self.backButtonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.backButtonTitleLabel.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor),
            self.backButtonTitleLabel.leadingAnchor.constraint(equalTo: self.backButton.trailingAnchor, constant: 12)
        ])

        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func configureDelegate(_ delegate: BackButtonDelegate) {
        self.delegate = delegate
    }

    // MARK: - Configure NavigationBar
    func configureTintColor(color: UIColor) {
        self.backButton.tintColor = color
        self.backButtonTitleLabel.textColor = color
        self.titleLabel.textColor = color
    }

    func configureBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }

    func configureAlpha(alpha: CGFloat) {
        self.backButtonTitleLabel.alpha = alpha
        self.titleLabel.alpha = alpha
        self.backgroundColor = self.backgroundColor?.withAlphaComponent(alpha)
    }

    func configureBackButtonTitle(_ title: String) {
        self.backButtonTitleLabel.text = title
    }

    func configureTitle(_ title: NSAttributedString) {
        self.titleLabel.attributedText = title
    }
}
