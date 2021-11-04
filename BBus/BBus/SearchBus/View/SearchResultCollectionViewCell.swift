//
//  SearchResultTableViewCell.swift
//  BBus
//
//  Created by 이지수 on 2021/11/03.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultCollectionViewCell"
    static let height: CGFloat = 70
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var detailInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    // MARK: - Configuration
    func configureLayout() {
        let labelLeftPadding: CGFloat = 10
        let titleDetailInfoLabelInterval: CGFloat = 4
        
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -titleDetailInfoLabelInterval/2),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelLeftPadding)
        ])
        
        self.addSubview(self.detailInfoLabel)
        self.detailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailInfoLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: titleDetailInfoLabelInterval/2),
            self.detailInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelLeftPadding)
        ])
    }
    
    private func configureUI() {
        self.backgroundColor = UIColor.white
    }
    
    func configureUI(title: String, detailInfo: NSMutableAttributedString) {
        self.titleLabel.text = title
        self.detailInfoLabel.attributedText = detailInfo
    }
}
