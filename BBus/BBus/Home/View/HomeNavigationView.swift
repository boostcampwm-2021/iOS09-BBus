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

    private var searchButtonDelegate: HomeSearchButtonDelegate? {
        didSet {
            self.searchButton.addAction(UIAction(handler: { _ in
                self.searchButtonDelegate?.shouldGoToSearchBusScene()
            }), for: .touchUpInside)
        }
    }
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyColor.bbusLightGray
        button.layer.borderColor = MyColor.bbusGray?.cgColor
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 3
        button.setTitle("버스 또는 정류장 검색", for: .normal)
        button.setTitleColor(MyColor.bbusGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    convenience init() {
        self.init(frame: CGRect(origin: CGPoint(), size: CGSize(width: 0, height: 50)))
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
        let navigationBottomBorderView = UIView()
        navigationBottomBorderView.backgroundColor = UIColor.gray
        self.addSubview(navigationBottomBorderView)
        navigationBottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBottomBorderView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            navigationBottomBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            navigationBottomBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            navigationBottomBorderView.heightAnchor.constraint(equalToConstant: 0.2)
        ])
        
        self.addSubview(self.searchButton)
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.searchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.searchButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            self.searchButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
        ])
        self.searchButton.titleLabel?.leftAnchor.constraint(equalTo: self.searchButton.leftAnchor, constant: 10).isActive = true
    }

    func configureDelegate(_ delegate: HomeSearchButtonDelegate) {
        self.searchButtonDelegate = delegate
    }

}
