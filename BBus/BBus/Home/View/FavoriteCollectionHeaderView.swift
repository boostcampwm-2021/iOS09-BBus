//
//  FavoriteHeader.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/02.
//

import UIKit

protocol FavoriteHeaderViewDelegate {
    func shouldGoToStationScene(headerView: UICollectionReusableView)
}

class FavoriteCollectionHeaderView: UICollectionReusableView {

    static let identifier = "FavoriteHeaderView"
    static let height: CGFloat = 70
    
    private var delegate: FavoriteHeaderViewDelegate? {
        didSet {
            self.gestureRecognizers?.forEach() { self.removeGestureRecognizer($0) }
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: #selector(headerViewTapped(_:)))
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func headerViewTapped(_ sender: UICollectionReusableView) {
        delegate?.shouldGoToStationScene(headerView: sender)
    }

    private lazy var stationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "여의도환승센터(4번승강장)"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = BBusColor.black
        return label
    }()
    private lazy var directionLabel: UILabel = {
        let label = UILabel()
        label.text = "여의도 공원 방면"
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
    
    // MARK: - Configuration
    private func configureLayout() {
        let leadingInterval: CGFloat = 20
        let titleBottomInterval: CGFloat = -35
        let titleDirectionInterval: CGFloat = 5

        self.addSubview(self.stationTitleLabel)
        self.stationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingInterval),
            self.stationTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: titleBottomInterval)
        ])

        self.addSubview(self.directionLabel)
        self.directionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.directionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingInterval),
            self.directionLabel.topAnchor.constraint(equalTo: self.stationTitleLabel.bottomAnchor, constant: titleDirectionInterval)
        ])
    }

    private func configureUI() {
        self.backgroundColor = BBusColor.white
    }
    
    func configureDelegate(_ delegate: FavoriteHeaderViewDelegate) {
        self.delegate = delegate
    }
}
