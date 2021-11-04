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

class KeyboardAccessoryView: UIView {

    private var numberDelegate: KeyboardAccessoryNumberButtonDelegate?
    private var characterDelegate: KeyboardAccessoryCharacterButtonDelegate?
    private var downKeyboardDelegate: KeyboardAccessoryDownKeyboardButtonDelegate?
    static let height: CGFloat = 50

    private lazy var numberButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Self.height * 0.7 / 2
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(named: "bbusGray")?.cgColor
        button.layer.borderWidth = 1
        button.setTitle("숫자", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.numberDelegate?.shouldShowNumberPad()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var characterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Self.height * 0.7 / 2
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(named: "bbusGray")?.cgColor
        button.layer.borderWidth = 1
        button.setTitle("문자", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.characterDelegate?.shouldShowCharacterPad()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var downKeyboardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        button.tintColor = UIColor.white
        button.addAction(UIAction(handler: { _ in
            self.downKeyboardDelegate?.shouldHideKeyboard()
        }), for: .touchUpInside)
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

        self.addSubview(self.numberButton)
        self.numberButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.numberButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17),
            self.numberButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.numberButton.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 0.15),
            self.numberButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height * 0.15)
        ])

        self.addSubview(self.characterButton)
        self.characterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.characterButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17),
            self.characterButton.leadingAnchor.constraint(equalTo: self.numberButton.trailingAnchor, constant: 10),
            self.characterButton.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 0.15),
            self.characterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height * 0.15)
        ])

        self.addSubview(self.downKeyboardButton)
        self.downKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.downKeyboardButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            self.downKeyboardButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.downKeyboardButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.downKeyboardButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])

    }

    private func configureUI() {
        self.backgroundColor = UIColor.darkGray
    }

    func configureDelegate(_ delegate: KeyboardAccessoryCharacterButtonDelegate & KeyboardAccessoryDownKeyboardButtonDelegate & KeyboardAccessoryNumberButtonDelegate) {
        self.downKeyboardDelegate = delegate
        self.characterDelegate = delegate
        self.numberDelegate = delegate
    }

    func configureButtonUI(by type: UIKeyboardType) {
        switch type {
        case .decimalPad:
            self.characterButton.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
            self.characterButton.layer.borderColor = UIColor(named: "bbusGray")?.cgColor
            self.numberButton.setTitleColor(UIColor.white, for: .normal)
            self.numberButton.layer.borderColor = UIColor.white.cgColor
        case .webSearch:
            self.numberButton.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
            self.numberButton.layer.borderColor = UIColor(named: "bbusGray")?.cgColor
            self.characterButton.setTitleColor(UIColor.white, for: .normal)
            self.characterButton.layer.borderColor = UIColor.white.cgColor
        default:
            break
        }
    }
}
