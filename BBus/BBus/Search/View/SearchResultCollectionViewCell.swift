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
        label.textColor = BBusColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var detailInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = BBusColor.gray
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
        self.backgroundColor = BBusColor.white
    }
    
    func configureBusUI(title: String, detailInfo: RouteType) {
        self.titleLabel.text = title
        self.detailInfoLabel.text = "\(detailInfo.rawValue) 버스"
        switch detailInfo {
        case .mainLine:
            self.titleLabel.textColor = BBusColor.bbusTypeBlue
        case .broadArea:
            self.titleLabel.textColor = BBusColor.bbusTypeRed
        case .customized:
            self.titleLabel.textColor = BBusColor.bbusTypeGreen
        case .circulation:
            self.titleLabel.textColor = BBusColor.black
        case .lateNight:
            self.titleLabel.textColor = BBusColor.black
        case .localLine:
            self.titleLabel.textColor = BBusColor.bbusTypeGreen
        }
    }
    
    func configureStationUI(title: String, titleMatchRange: [NSRange], arsId: String, arsIdMatchRange: [NSRange]) {
        let attributedTitle = NSMutableAttributedString(string: title)
        titleMatchRange.forEach {
            attributedTitle.addAttributes([.foregroundColor:BBusColor.bbusSearchRed as Any], range: $0)
        }
        self.titleLabel.attributedText = attributedTitle
        
        let attributedArsId = NSMutableAttributedString(string: arsId)
        arsIdMatchRange.forEach {
            attributedArsId.addAttributes([.foregroundColor:BBusColor.bbusSearchRed as Any], range: $0)
        }
        self.detailInfoLabel.attributedText = attributedArsId
    }
}
