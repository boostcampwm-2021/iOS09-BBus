//
//  NavigationView.swift
//  BBus
//
//  Created by 이지수 on 2021/11/03.
//

import UIKit

class HomeNavigationView: UIView {
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "bbusLightGray")
        button.layer.borderColor = UIColor(named: "bbusGray")?.cgColor
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 3
        button.setTitle("버스 또는 정류장 검색", for: .normal)
        button.setTitleColor(UIColor(named: "bbusGray"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }
    
    func configureLayout() {
        let navigationBottomBorderView = UIView()
        navigationBottomBorderView.backgroundColor = UIColor.gray
        navigationBottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(navigationBottomBorderView)
        NSLayoutConstraint.activate([
            navigationBottomBorderView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            navigationBottomBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            navigationBottomBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            navigationBottomBorderView.heightAnchor.constraint(equalToConstant: 0.2)
        ])
        
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.searchButton)
        NSLayoutConstraint.activate([
            self.searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.searchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.searchButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            self.searchButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
        ])
        self.searchButton.titleLabel?.leftAnchor.constraint(equalTo: self.searchButton.leftAnchor, constant: 10).isActive = true
    }

}
