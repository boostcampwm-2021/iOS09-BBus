//
//  SimpleCollectionHeaderView.swift
//  BBus
//
//  Created by 이지수 on 2021/11/04.
//

import UIKit

final class SimpleCollectionHeaderView: UICollectionReusableView {
    
    static let identifier = "SearchResultHeaderView"
    static let height: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = BBusColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Configuration
    func configureLayout() {
        self.addSubviews(self.title)
        
        let titleLeftPadding: CGFloat = 10
        NSLayoutConstraint.activate([
            self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: titleLeftPadding),
            self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureUI() {
        self.backgroundColor = BBusColor.bbusLightGray
    }
    
    func configure(title: String) {
        self.title.text = title
        self.title.sizeToFit()
    }
}
