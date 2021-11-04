//
//  BBusSearchKeyboardToolBar.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/04.
//

import UIKit

protocol ToolBarNumberButtonDelegate {
    func shouldShowNumPad()
}

class BBusSearchKeyboardAccessoryView: UIView {

    private var numberDelegate: ToolBarNumberButtonDelegate?
    static let height: CGFloat = 50

    private lazy var numberKeyboardChangerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Self.height * 0.7 / 2
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.setTitle("숫자", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: .focused)
        button.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
        button.addAction(UIAction(handler: { _ in
            print("good")
            self.numberDelegate?.shouldShowNumPad()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var charKeyboardChangerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Self.height * 0.7 / 2
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.setTitle("문자", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: .focused)
        button.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
//        button.frame.size = CGSize(width: self.frame.width * 0.15, height: 0)
        button.addAction(UIAction(handler: { _ in
            print("good")
            self.numberDelegate?.shouldShowNumPad()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var hideKeyboardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        button.tintColor = UIColor.white
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

        self.addSubview(self.numberKeyboardChangerButton)
        self.numberKeyboardChangerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.numberKeyboardChangerButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17),
            self.numberKeyboardChangerButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.numberKeyboardChangerButton.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 0.15),
            self.numberKeyboardChangerButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height * 0.15)
        ])

        self.addSubview(self.charKeyboardChangerButton)
        self.charKeyboardChangerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.charKeyboardChangerButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17),
            self.charKeyboardChangerButton.leadingAnchor.constraint(equalTo: self.numberKeyboardChangerButton.trailingAnchor, constant: 10),
            self.charKeyboardChangerButton.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 0.15),
            self.charKeyboardChangerButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height * 0.15)
        ])

        self.addSubview(self.hideKeyboardButton)
        self.hideKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.hideKeyboardButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            self.hideKeyboardButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.hideKeyboardButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.hideKeyboardButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])

    }

    private func configureUI() {
        self.backgroundColor = UIColor.darkGray
    }
}
