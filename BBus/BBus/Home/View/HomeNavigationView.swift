//
//  NavigationView.swift
//  BBus
//
//  Created by 이지수 on 2021/11/03.
//

import UIKit

protocol HomeSearchButtonDelegate {
    func shouldGoToSearchBusScene()
}

class HomeNavigationView: UIView {

    static let height: CGFloat = 50.0

    private var searchButtonDelegate: HomeSearchButtonDelegate? {
        didSet {
            self.searchButton.addAction(UIAction(handler: { _ in
                self.searchButtonDelegate?.shouldGoToSearchBusScene()
            }), for: .touchUpInside)
        }
    }
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = BBusColor.bbusLightGray
        button.layer.borderColor = BBusColor.bbusGray?.cgColor
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 3
        button.setTitle("버스 또는 정류장 검색", for: .normal)
        button.setTitleColor(BBusColor.bbusGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    private lazy var bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = BBusColor.gray
        return view
    }()
    
    convenience init() {
        self.init(frame: CGRect(origin: CGPoint(), size: CGSize(width: 0, height: Self.height)))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }
    
    // MARK: - Configuration
    func configureLayout() {
        let borderHeight: CGFloat = 0.2
        self.addSubview(self.bottomBorderView)
        self.bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.bottomBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bottomBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomBorderView.heightAnchor.constraint(equalToConstant: borderHeight)
        ])

        let searchButtonWidthRatio: CGFloat = 0.9
        let searchButtonHeightRatio: CGFloat = 0.6
        let searchButtonTitleLeftPadding: CGFloat = 10
        self.addSubview(self.searchButton)
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.searchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.searchButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: searchButtonWidthRatio),
            self.searchButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: searchButtonHeightRatio)
        ])
        self.searchButton.titleLabel?.leadingAnchor.constraint(equalTo: self.searchButton.leadingAnchor, constant: searchButtonTitleLeftPadding).isActive = true
    }

    func configureDelegate(_ delegate: HomeSearchButtonDelegate) {
        self.searchButtonDelegate = delegate
    }

}
