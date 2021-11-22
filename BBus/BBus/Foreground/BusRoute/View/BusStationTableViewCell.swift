//
//  BusStationTableViewCell.swift
//  BBus
//
//  Created by 최수정 on 2021/11/02.
//

import UIKit

class BusStationTableViewCell: UITableViewCell {
    
    var titleLeadingOffset: CGFloat { return 0 }
    var lineTrailingOffset: CGFloat { return 0 }
    var stationTitleLabelFontSize: CGFloat { return 0 }
    var stationDescriptionLabelFontSize: CGFloat { return 0 }
    var stackViewSpacing: CGFloat { return 0 }
    var labelStackViewRightMargin: CGFloat { return 0 }
    
    lazy var beforeCongestionLineView = UIView()
    private lazy var afterCongestionLineView = UIView()
    lazy var centerImageView = UIImageView()
    private lazy var stationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: self.stationTitleLabelFontSize, weight: .semibold)
        label.textColor = BBusColor.black
        return label
    }()
    private lazy var stationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: self.stationDescriptionLabelFontSize)
        label.textColor = BBusColor.systemGray
        return label
    }()
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.stationTitleLabel, self.stationDescriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = self.stackViewSpacing
        return stackView
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureLayout()
        self.configureColor()
        self.selectionStyle = .none
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureLayout()
        self.configureColor()
        self.selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.stationTitleLabel.text = ""
        self.stationDescriptionLabel.text = ""
    }

    // MARK: - Configure
    func configureLayout() {
        let congestionLineViewHeightMultiplier: CGFloat = 0.5
        let congestionLineViewWidth: CGFloat = 3
        
        self.addSubview(self.labelStackView)
        self.labelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.titleLeadingOffset),
            self.labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: self.labelStackViewRightMargin),
            self.labelStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.addSubview(self.beforeCongestionLineView)
        self.beforeCongestionLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.beforeCongestionLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: congestionLineViewHeightMultiplier),
            self.beforeCongestionLineView.widthAnchor.constraint(equalToConstant: congestionLineViewWidth),
            self.beforeCongestionLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.beforeCongestionLineView.centerXAnchor.constraint(equalTo: self.labelStackView.leadingAnchor, constant: self.lineTrailingOffset)
        ])
        
        self.addSubview(self.afterCongestionLineView)
        self.afterCongestionLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.afterCongestionLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: congestionLineViewHeightMultiplier),
            self.afterCongestionLineView.widthAnchor.constraint(equalToConstant: congestionLineViewWidth),
            self.afterCongestionLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.afterCongestionLineView.centerXAnchor.constraint(equalTo: self.beforeCongestionLineView.centerXAnchor)
        ])
        
        self.addSubview(self.centerImageView)
        self.centerImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureColor() {
        self.backgroundColor = BBusColor.white
    }

    func configure(beforeColor: UIColor?, afterColor: UIColor?, title: String, description: String) {
        self.beforeCongestionLineView.backgroundColor = beforeColor
        self.afterCongestionLineView.backgroundColor = afterColor
        self.stationTitleLabel.text = title
        self.stationDescriptionLabel.text = description
    }
}
