//
//  FavoriteCollectionHeaderView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/02.
//

import UIKit

protocol FavoriteHeaderViewDelegate: AnyObject {
    func shouldGoToStationScene(headerView: UICollectionReusableView)
}

class FavoriteCollectionHeaderView: UICollectionReusableView {

    static let identifier = "FavoriteHeaderView"
    static let height: CGFloat = 70
    
    private weak var delegate: FavoriteHeaderViewDelegate? {
        didSet {
            self.gestureRecognizers?.forEach() { self.removeGestureRecognizer($0) }
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: #selector(self.headerViewTapped(_:)))
            self.addGestureRecognizer(tapGesture)
        }
    }

    private lazy var stationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = BBusColor.black
        return label
    }()
    private lazy var arsIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = BBusColor.bbusGray
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
        self.configureUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
        self.configureUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.stationTitleLabel.text = ""
        self.arsIdLabel.text = ""
    }
    
    // MARK: - Configuration
    private func configureLayout() {
        let leadingInterval: CGFloat = 20
        let titleBottomInterval: CGFloat = -35
        let titleDirectionInterval: CGFloat = 5

        self.addSubviews(self.stationTitleLabel, self.arsIdLabel)
        
        NSLayoutConstraint.activate([
            self.stationTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingInterval),
            self.stationTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: titleBottomInterval)
        ])

        NSLayoutConstraint.activate([
            self.arsIdLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingInterval),
            self.arsIdLabel.topAnchor.constraint(equalTo: self.stationTitleLabel.bottomAnchor, constant: titleDirectionInterval)
        ])
    }

    @objc private func headerViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.shouldGoToStationScene(headerView: self)
    }

    private func configureUI() {
        self.backgroundColor = BBusColor.white
    }
    
    func configureDelegate(_ delegate: FavoriteHeaderViewDelegate) {
        self.delegate = delegate
    }

    func configure(title: String, arsId: String) {
        self.stationTitleLabel.text = title
        self.arsIdLabel.text = arsId
    }
}
