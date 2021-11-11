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

    static let height: CGFloat = 43
    
    private var delegate: BackButtonDelegate? {
        didSet {
            self.backButton.addAction(UIAction(handler: { _ in
                self.delegate?.touchedBackButton()
            }), for: .touchUpInside)
        }
    }

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.tintColor = BBusColor.white
        button.setBackgroundImage(BBusImage.navigationBack, for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    private lazy var backButtonTitleLabel: UILabel = {
        let buttonTitleFontSize: CGFloat = 18

        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: buttonTitleFontSize, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let labelFontSize: CGFloat = 18

        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    convenience init() {
        self.init(frame: CGRect())

        self.configureLayout()
    }

    // MARK: - Configure
    func configureLayout() {
        let backButtonWidthAnchor: CGFloat = 22
        let backButtonHeightAnchor: CGFloat = 30
        let backButtonLeadingAnchor: CGFloat = 16
        let termBackButtonToBackButtonTitle: CGFloat = 12

        self.heightAnchor.constraint(equalToConstant: Self.height).isActive = true

        self.addSubview(self.backButton)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.backButton.widthAnchor.constraint(equalToConstant: backButtonWidthAnchor),
            self.backButton.heightAnchor.constraint(equalToConstant: backButtonHeightAnchor),
            self.backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: backButtonLeadingAnchor),
        ])

        self.addSubview(self.backButtonTitleLabel)
        self.backButtonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.backButtonTitleLabel.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor),
            self.backButtonTitleLabel.leadingAnchor.constraint(equalTo: self.backButton.trailingAnchor, constant: termBackButtonToBackButtonTitle)
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

    func configureBackgroundColor(color: UIColor?) {
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
