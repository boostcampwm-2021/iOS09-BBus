//
//  SearchBusNavigationView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/03.
//

import UIKit

protocol SearchBackButtonDelegate {
    func shouldNavigationPop()
}

protocol BusTabButtonDelegate {
    func shouldBusTabSelect()
}

protocol StationTabButtonDelegate {
    func shouldStationTabSelect()
}

class SearchNavigationView: UIView {

    private var backButtonDelegate: SearchBackButtonDelegate?
    private var busTabButtonDelegate: BusTabButtonDelegate?
    private var stationTabButtonDelegate: StationTabButtonDelegate?

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: largeConfig), for: .normal)
        button.tintColor = MyColor.black
        button.addAction(UIAction(handler: { _ in
            self.backButtonDelegate?.shouldNavigationPop()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = MyColor.bbusLightGray
        textField.layer.borderColor = MyColor.bbusGray?.cgColor
        textField.layer.borderWidth = 0.3
        textField.layer.cornerRadius = 3
        textField.placeholder = "버스 검색" // 정거장일땐 정거장 검색
        textField.clearButtonMode = .whileEditing
        textField.becomeFirstResponder()
        textField.keyboardType = .decimalPad
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        let accessoryView = KeyboardAccessoryView()
        accessoryView.configureDelegate(self)
        textField.inputAccessoryView = accessoryView
        textField.tintColor = MyColor.bbusTypeRed
        let paddingView = UIView()
        paddingView.frame.size = CGSize(width: 10, height: 0)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    private lazy var firstSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = MyColor.darkGray
        return view
    }()
    private lazy var busTabButton: UIButton = {
        let button = UIButton()
        button.setTitle("버스", for: .normal)
        button.setTitleColor(MyColor.bbusGray, for: .normal)
        button.setImage(UIImage(systemName: "bus.fill"), for: .normal)
        button.tintColor = MyColor.bbusGray
        button.addAction(UIAction(handler: { _ in
            self.busTabButtonDelegate?.shouldBusTabSelect()
        }), for: .touchUpInside)
        return button
    }()
    private lazy var stationTabButton: UIButton = {
        let button = UIButton()
        button.setTitle("정거장", for: .normal)
        button.setTitleColor(MyColor.bbusGray, for: .normal)
        button.setImage(UIImage(systemName: "bitcoinsign.circle"), for: .normal)
        button.tintColor = MyColor.bbusGray
        button.addAction(UIAction(handler: { _ in
            self.stationTabButtonDelegate?.shouldStationTabSelect()
        }), for: .touchUpInside)
        return button
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
        let half: CGFloat = 0.5
        let twice: CGFloat = 2
        let backButtonWidthRatio: CGFloat = 0.15

        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.backButton)
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: half),
            self.backButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: backButtonWidthRatio)
        ])

        let textFieldTopMargin: CGFloat = 7
        let textFieldWidthRatio: CGFloat = 0.8

        self.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.searchTextField)
        NSLayoutConstraint.activate([
            self.searchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: textFieldTopMargin),
            self.searchTextField.leadingAnchor.constraint(equalTo: self.backButton.trailingAnchor),
            self.searchTextField.heightAnchor.constraint(equalTo: self.backButton.heightAnchor, constant: -textFieldTopMargin * twice),
            self.searchTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: textFieldWidthRatio)
        ])

        let separatorHeight: CGFloat = 0.3

        self.firstSeparateView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.firstSeparateView)
        NSLayoutConstraint.activate([
            self.firstSeparateView.topAnchor.constraint(equalTo: self.backButton.bottomAnchor),
            self.firstSeparateView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.firstSeparateView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.firstSeparateView.heightAnchor.constraint(equalToConstant: separatorHeight)
        ])

        self.busTabButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.busTabButton)
        NSLayoutConstraint.activate([
            self.busTabButton.topAnchor.constraint(equalTo: self.firstSeparateView.bottomAnchor),
            self.busTabButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.busTabButton.heightAnchor.constraint(equalTo: self.backButton.heightAnchor),
            self.busTabButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: half)
        ])

        self.stationTabButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stationTabButton)
        NSLayoutConstraint.activate([
            self.stationTabButton.topAnchor.constraint(equalTo: self.firstSeparateView.bottomAnchor),
            self.stationTabButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stationTabButton.heightAnchor.constraint(equalTo: self.backButton.heightAnchor),
            self.stationTabButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: half),

        ])

        let buttonContentInterval: CGFloat = 10

//        if #available(iOS 15.0, *) {
//            var buttonPaddingConfiguration = UIButton.Configuration.plain()
//            buttonPaddingConfiguration.imagePadding = 15
//            self.busTabButton.configuration = buttonPaddingConfiguration
//            self.stationTabButton.configuration = buttonPaddingConfiguration
//        }
//        else {
        self.busTabButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: buttonContentInterval)
        self.stationTabButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: buttonContentInterval)
        self.busTabButton.titleEdgeInsets = .init(top: 0, left: buttonContentInterval, bottom: 0, right: 0)
        self.stationTabButton.titleEdgeInsets = .init(top: 0, left: buttonContentInterval, bottom: 0, right: 0)
//        }
    }

    func hideKeyboard() {
        self.searchTextField.resignFirstResponder()
    }

    func configureBackButtonDelegate(_ delegate: SearchBackButtonDelegate) {
        self.backButtonDelegate = delegate
    }

    func configureTabButtonDelegate(_ delegate: BusTabButtonDelegate & StationTabButtonDelegate) {
        self.busTabButtonDelegate = delegate
        self.stationTabButtonDelegate = delegate
    }

    func configure(searchType: SearchType) {
        switch searchType {
        case .bus:
            self.busTabButton.tintColor = MyColor.bbusSearchRed
            self.busTabButton.setTitleColor(MyColor.bbusSearchRed, for: .normal)
            self.searchTextField.placeholder = "버스 검색"
            self.stationTabButton.tintColor = MyColor.bbusGray
            self.stationTabButton.setTitleColor(MyColor.bbusGray, for: .normal)
            self.showNumberKeyboard()
        case .station:
            self.stationTabButton.tintColor = MyColor.bbusSearchRed
            self.stationTabButton.setTitleColor(MyColor.bbusSearchRed, for: .normal)
            self.searchTextField.placeholder = "정류장, ID 검색"
            self.busTabButton.tintColor = MyColor.bbusGray
            self.busTabButton.setTitleColor(MyColor.bbusGray, for: .normal)
            self.showCharacterKeyboard()
        }
    }

    private func showNumberKeyboard() {
        self.searchTextField.keyboardType = .decimalPad
        self.searchTextField.reloadInputViews()
        if let accessoryView = self.searchTextField.inputAccessoryView as? KeyboardAccessoryView {
            accessoryView.configureButtonUI(by: .decimalPad)
        }
    }

    private func showCharacterKeyboard() {
        self.searchTextField.keyboardType = .webSearch
        self.searchTextField.reloadInputViews()
        if let accessoryView = self.searchTextField.inputAccessoryView as? KeyboardAccessoryView {
            accessoryView.configureButtonUI(by: .webSearch)
        }
    }
}

extension SearchNavigationView: KeyboardAccessoryCharacterButtonDelegate {
    func shouldShowCharacterPad() {
        self.showCharacterKeyboard()
    }
}

extension SearchNavigationView: KeyboardAccessoryDownKeyboardButtonDelegate {
    func shouldHideKeyboard() {
        self.hideKeyboard()
    }
}

extension SearchNavigationView: KeyboardAccessoryNumberButtonDelegate {
    func shouldShowNumberPad() {
        self.showNumberKeyboard()
    }
}
