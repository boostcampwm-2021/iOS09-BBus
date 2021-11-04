//
//  SearchBusNavigationView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/03.
//

import UIKit

class SearchBusNavigationView: UIView {

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: largeConfig), for: .normal)
        button.tintColor = UIColor.darkText
        return button
    }()
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(named: "bbusLightGray")
        textField.layer.borderColor = UIColor(named: "bbusGray")?.cgColor
        textField.layer.borderWidth = 0.3
        textField.layer.cornerRadius = 3
        textField.placeholder = "버스 검색" // 정거장일땐 정거장 검색
        textField.clearButtonMode = .whileEditing
        textField.becomeFirstResponder()
        textField.keyboardType = .decimalPad
        textField.inputAccessoryView = BBusSearchKeyboardAccessoryView()
        textField.tintColor = UIColor(named: "bbusSearchRed")
        let paddingView = UIView()
        paddingView.frame.size = CGSize(width: 10, height: 0)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    private lazy var firstSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    private lazy var busTabButton: UIButton = {
        let button = UIButton()
        button.setTitle("버스", for: .normal)
        button.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
        button.setImage(UIImage(systemName: "bus.fill"), for: .normal)
        button.tintColor = UIColor(named: "bbusSearchRed")
        return button
    }()
    private lazy var stationTabButton: UIButton = {
        let button = UIButton()
        button.setTitle("정거장", for: .normal)
        button.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
        button.setImage(UIImage(systemName: "bitcoinsign.circle"), for: .normal)
        button.tintColor = UIColor(named: "bbusSearchRed")
        return button
    }()
    private lazy var secondSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    convenience init() {
        self.init(frame: CGRect())
    }

    private func configureLayout() {
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.backButton)
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.backButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15)
        ])

        self.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.searchTextField)
        NSLayoutConstraint.activate([
            self.searchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            self.searchTextField.leadingAnchor.constraint(equalTo: self.backButton.trailingAnchor),
            self.searchTextField.heightAnchor.constraint(equalTo: self.backButton.heightAnchor, constant: -14),
            self.searchTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])

        self.firstSeparateView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.firstSeparateView)
        NSLayoutConstraint.activate([
            self.firstSeparateView.topAnchor.constraint(equalTo: self.backButton.bottomAnchor),
            self.firstSeparateView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.firstSeparateView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.firstSeparateView.heightAnchor.constraint(equalToConstant: 0.3)
        ])

        self.busTabButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.busTabButton)
        NSLayoutConstraint.activate([
            self.busTabButton.topAnchor.constraint(equalTo: self.firstSeparateView.bottomAnchor),
            self.busTabButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.busTabButton.heightAnchor.constraint(equalTo: self.backButton.heightAnchor),
            self.busTabButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])

        self.stationTabButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stationTabButton)
        NSLayoutConstraint.activate([
            self.stationTabButton.topAnchor.constraint(equalTo: self.firstSeparateView.bottomAnchor),
            self.stationTabButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stationTabButton.heightAnchor.constraint(equalTo: self.backButton.heightAnchor),
            self.stationTabButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),

        ])

        self.secondSeparateView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.secondSeparateView)
        NSLayoutConstraint.activate([
            self.secondSeparateView.topAnchor.constraint(equalTo: self.busTabButton.bottomAnchor),
            self.secondSeparateView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.secondSeparateView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.secondSeparateView.heightAnchor.constraint(equalToConstant: 0.3)
        ])

//        if #available(iOS 15.0, *) {
//            var buttonPaddingConfiguration = UIButton.Configuration.plain()
//            buttonPaddingConfiguration.imagePadding = 15
//            self.busTabButton.configuration = buttonPaddingConfiguration
//            self.stationTabButton.configuration = buttonPaddingConfiguration
//        }
//        else {
        self.busTabButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.stationTabButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.busTabButton.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        self.stationTabButton.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
//        }
    }
}