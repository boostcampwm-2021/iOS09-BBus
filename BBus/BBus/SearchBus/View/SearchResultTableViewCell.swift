//
//  SearchResultTableViewCell.swift
//  BBus
//
//  Created by 이지수 on 2021/11/03.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
    private lazy var detailInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "bbusGray")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureLayout() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 3),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
        self.detailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.detailInfoLabel)
        NSLayoutConstraint.activate([
            self.detailInfoLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 3),
            self.detailInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
    }
    
    func configureUI(title: String, detailInfo: String) {
        self.titleLabel.text = title
        self.detailInfoLabel.text = detailInfo
    }
}
