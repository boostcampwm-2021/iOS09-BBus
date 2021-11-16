//
//  NoneInfoTableViewCell.swift
//  BBus
//
//  Created by 이지수 on 2021/11/16.
//

import UIKit

class NoneInfoTableViewCell: UITableViewCell {
    
    static let reusableID = "NoneInfoTableViewCell"
    static let height: CGFloat = 130

    private lazy var noInfoImageView: UIImageView = {
        let imageView = UIImageView(image: BBusImage.info)
        imageView.tintColor = BBusColor.bbusGray
        return imageView
    }()
    private lazy var noInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "도착예정 정보없음"
        label.textColor = BBusColor.bbusGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }
    
    private func configureLayout() {
        self.addSubviews(self.noInfoImageView, self.noInfoLabel)
        
        NSLayoutConstraint.activate([
            self.noInfoImageView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            self.noInfoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.noInfoLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
            self.noInfoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
