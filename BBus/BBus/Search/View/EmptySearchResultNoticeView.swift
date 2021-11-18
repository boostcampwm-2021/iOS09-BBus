//
//  EmptySearchResultNoticeView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/18.
//

import UIKit

class EmptySearchResultNoticeView: UIView {

    private var searchType: SearchType = .bus
    private lazy var noticeImage: UIImageView = {
        let imageView = UIImageView(image: BBusImage.exclamationMark)
        imageView.tintColor = BBusColor.bbusGray
        return imageView
    }()
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "검색결과가 없습니다."
        label.textColor = BBusColor.bbusGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    private lazy var exchangeAnotherTabLabel: UILabel = {
        let label = UILabel()
        label.textColor = BBusColor.bbusSearchRed
        label.font = UIFont.systemFont(ofSize: 15)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.onExchangeLabelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        label.text = "검색 결과"
        return label
    }()
    private var busTabButtonDelegate: BusTabButtonDelegate?
    private var stationTabButtonDelegate: StationTabButtonDelegate?

    convenience init(searchType: SearchType) {
        self.init(frame: CGRect())
        self.searchType = searchType
        switch self.searchType {
        case .bus:
            self.exchangeAnotherTabLabel.text = "정류장 검색 결과 >"
        case .station:
            self.exchangeAnotherTabLabel.text = "< 버스 검색 결과"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    func configureDelegate(_ delegate: BusTabButtonDelegate & StationTabButtonDelegate) {
        self.busTabButtonDelegate = delegate
        self.stationTabButtonDelegate = delegate
    }

    private func configureLayout() {
        self.addSubviews(self.noticeImage, self.noticeLabel, self.exchangeAnotherTabLabel)

        NSLayoutConstraint.activate([
            self.noticeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.noticeImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.noticeImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            self.noticeImage.heightAnchor.constraint(equalTo: self.noticeImage.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            self.noticeLabel.topAnchor.constraint(equalTo: self.noticeImage.bottomAnchor, constant: 15),
            self.noticeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            self.exchangeAnotherTabLabel.topAnchor.constraint(equalTo: self.noticeLabel.bottomAnchor, constant: 15),
            self.exchangeAnotherTabLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    @objc private func onExchangeLabelTapped(_ sender: UITapGestureRecognizer) {

        switch self.searchType {
        case .bus:
            self.stationTabButtonDelegate?.shouldStationTabSelect()
        case .station:
            self.busTabButtonDelegate?.shouldBusTabSelect()
        }
    }

}
