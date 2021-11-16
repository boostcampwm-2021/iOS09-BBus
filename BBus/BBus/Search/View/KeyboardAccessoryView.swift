//
//  BBusSearchKeyboardToolBar.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/04.
//

import UIKit

protocol KeyboardAccessoryNumberButtonDelegate {
    func shouldShowNumberPad()
}

protocol KeyboardAccessoryCharacterButtonDelegate {
    func shouldShowCharacterPad()
}

protocol KeyboardAccessoryDownKeyboardButtonDelegate {
    func shouldHideKeyboard()
}

final class KeyboardAccessoryView: UIView {

    private var numberDelegate: KeyboardAccessoryNumberButtonDelegate? {
        didSet {
            self.numberButton.addAction(UIAction(handler: { _ in
                self.numberDelegate?.shouldShowNumberPad()
            }), for: .touchUpInside)
        }
    }
    private var characterDelegate: KeyboardAccessoryCharacterButtonDelegate? {
        didSet {
            self.characterButton.addAction(UIAction(handler: { _ in
                self.characterDelegate?.shouldShowCharacterPad()
            }), for: .touchUpInside)
        }
    }
    private var downKeyboardDelegate: KeyboardAccessoryDownKeyboardButtonDelegate? {
        didSet {
            self.downKeyboardButton.addAction(UIAction(handler: { _ in
                self.downKeyboardDelegate?.shouldHideKeyboard()
            }), for: .touchUpInside)
        }
    }
    static let height: CGFloat = 50

    private lazy var numberButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Self.height * 0.7 / 2
        button.clipsToBounds = true
        button.layer.borderColor = BBusColor.bbusGray?.cgColor
        button.layer.borderWidth = 1
        button.setTitle("숫자", for: .normal)
        button.backgroundColor = BBusColor.clear
        button.setTitleColor(BBusColor.bbusGray, for: .normal)
        return button
    }()
    private lazy var characterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Self.height * 0.7 / 2
        button.clipsToBounds = true
        button.layer.borderColor = BBusColor.bbusGray?.cgColor
        button.layer.borderWidth = 1
        button.setTitle("문자", for: .normal)
        button.backgroundColor = BBusColor.clear
        button.setTitleColor(BBusColor.bbusGray, for: .normal)
        return button
    }()
    private lazy var downKeyboardButton: UIButton = {
        let button = UIButton()
        button.setImage(BBusImage.keyboardDown, for: .normal)
        button.tintColor = BBusColor.white
        return button
    }()

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Self.height))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
        self.configureUI()
    }

    private func configureLayout() {

        let buttonWidthRatio: CGFloat = 0.17
        let buttonLeadingInterval: CGFloat = 20
        let heightMarginRatio: CGFloat = 0.15

        self.addSubview(self.numberButton)
        self.numberButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.numberButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidthRatio),
            self.numberButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: buttonLeadingInterval),
            self.numberButton.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * heightMarginRatio),
            self.numberButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height * heightMarginRatio)
        ])

        let buttonInterval: CGFloat = 10

        self.addSubview(self.characterButton)
        self.characterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.characterButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidthRatio),
            self.characterButton.leadingAnchor.constraint(equalTo: self.numberButton.trailingAnchor, constant: buttonInterval),
            self.characterButton.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * heightMarginRatio),
            self.characterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height * heightMarginRatio)
        ])

        let buttonTrailingInterval: CGFloat = 10

        self.addSubview(self.downKeyboardButton)
        self.downKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.downKeyboardButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: buttonWidthRatio),
            self.downKeyboardButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -buttonTrailingInterval),
            self.downKeyboardButton.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * heightMarginRatio),
            self.downKeyboardButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height * heightMarginRatio)
        ])

    }

    private func configureUI() {
        self.backgroundColor = BBusColor.darkGray
    }

    func configureDelegate(_ delegate: KeyboardAccessoryCharacterButtonDelegate & KeyboardAccessoryDownKeyboardButtonDelegate & KeyboardAccessoryNumberButtonDelegate) {
        self.downKeyboardDelegate = delegate
        self.characterDelegate = delegate
        self.numberDelegate = delegate
    }

    func configureButtonUI(by type: UIKeyboardType) {
        switch type {
        case .decimalPad:
            self.characterButton.setTitleColor(BBusColor.bbusGray, for: .normal)
            self.characterButton.layer.borderColor = BBusColor.bbusGray?.cgColor
            self.numberButton.setTitleColor(BBusColor.white, for: .normal)
            self.numberButton.layer.borderColor = BBusColor.white.cgColor
        case .webSearch:
            self.numberButton.setTitleColor(BBusColor.bbusGray, for: .normal)
            self.numberButton.layer.borderColor = BBusColor.bbusGray?.cgColor
            self.characterButton.setTitleColor(BBusColor.white, for: .normal)
            self.characterButton.layer.borderColor = BBusColor.white.cgColor
        default:
            break
        }
    }
}
