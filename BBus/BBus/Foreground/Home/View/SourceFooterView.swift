//
//  CollectionReusableView.swift
//  BBus
//
//  Created by 이지수 on 2021/11/25.
//

import UIKit

final class SourceFooterView: UICollectionReusableView {
    
    static let identifier = "SourceFooterView"
    static let height: CGFloat = 100
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.text = "출처 : 서울특별시"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = BBusColor.bbusGray
        return label
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }
    
    private func configureLayout() {
        self.addSubviews(self.sourceLabel)
        
        let half: CGFloat = 0.5
        NSLayoutConstraint.activate([
            self.sourceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Self.height * half),
            self.sourceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
