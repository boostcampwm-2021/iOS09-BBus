//
//  SearchResultScrollView.swift
//  BBus
//
//  Created by 이지수 on 2021/11/04.
//

import UIKit

final class SearchResultScrollView: UIScrollView {

    static let indicatorHeight: CGFloat = 3

    private lazy var busResultCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: self.collectionViewLayout())
        collectionView.backgroundColor = BBusColor.bbusLightGray
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collectionView.register(SimpleCollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SimpleCollectionHeaderView.identifier)
        return collectionView
    }()
    private lazy var stationResultCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: self.collectionViewLayout())
        collectionView.backgroundColor = BBusColor.bbusLightGray
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collectionView.register(SimpleCollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SimpleCollectionHeaderView.identifier)
        return collectionView
    }()
    private lazy var leftFakeIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = BBusColor.bbusTypeRed
        return view
    }()
    private lazy var rightFakeIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = BBusColor.bbusTypeRed
        return view
    }()
    private lazy var collectionViewSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = BBusColor.darkGray
        return view
    }()
    private lazy var emptyBusSearchResultNoticeView = EmptySearchResultNoticeView(searchType: .bus)
    private lazy var emptyStationSearchResultNoticeView = EmptySearchResultNoticeView(searchType: .station)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }

    func configureLayout() {
        let twice: CGFloat = 2
        let half: CGFloat = 0.5
        let quater: CGFloat = 0.25
        let contentView = UIView()
        
        self.addSubviews(contentView, self.emptyBusSearchResultNoticeView, self.emptyStationSearchResultNoticeView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor, multiplier: twice),
            contentView.heightAnchor.constraint(equalTo: self.frameLayoutGuide.heightAnchor)
        ])
        
        
        contentView.addSubviews(self.collectionViewSeparateView, self.rightFakeIndicatorView, self.leftFakeIndicatorView, self.stationResultCollectionView, self.busResultCollectionView)

        NSLayoutConstraint.activate([
            self.busResultCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.busResultCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultScrollView.indicatorHeight),
            self.busResultCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.busResultCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: half)
        ])

        NSLayoutConstraint.activate([
            self.stationResultCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.stationResultCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultScrollView.indicatorHeight),
            self.stationResultCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.stationResultCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: half)
        ])

        NSLayoutConstraint.activate([
            self.leftFakeIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.leftFakeIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.leftFakeIndicatorView.heightAnchor.constraint(equalToConstant: SearchResultScrollView.indicatorHeight),
            self.leftFakeIndicatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: quater)
        ])
        
        NSLayoutConstraint.activate([
            self.rightFakeIndicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.rightFakeIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.rightFakeIndicatorView.heightAnchor.constraint(equalToConstant: SearchResultScrollView.indicatorHeight),
            self.rightFakeIndicatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
        ])

        let separatorHeight: CGFloat = 0.3
        NSLayoutConstraint.activate([
            self.collectionViewSeparateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.collectionViewSeparateView.topAnchor.constraint(equalTo: self.rightFakeIndicatorView.bottomAnchor),
            self.collectionViewSeparateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.collectionViewSeparateView.heightAnchor.constraint(equalToConstant: separatorHeight)
        ])

        NSLayoutConstraint.activate([
            self.emptyBusSearchResultNoticeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.emptyBusSearchResultNoticeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultScrollView.indicatorHeight),
            self.emptyBusSearchResultNoticeView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.emptyBusSearchResultNoticeView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: half)
        ])

        NSLayoutConstraint.activate([
            self.emptyStationSearchResultNoticeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.emptyStationSearchResultNoticeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SearchResultScrollView.indicatorHeight),
            self.emptyStationSearchResultNoticeView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.emptyStationSearchResultNoticeView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: half)
            ])

    }

    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        self.busResultCollectionView.delegate = delegate
        self.busResultCollectionView.dataSource = delegate
        self.stationResultCollectionView.delegate = delegate
        self.stationResultCollectionView.dataSource = delegate
    }

    func configureExchangeLabelDelegate(_ delegate: BusTabButtonDelegate & StationTabButtonDelegate) {
        self.emptyStationSearchResultNoticeView.configureDelegate(delegate)
        self.emptyBusSearchResultNoticeView.configureDelegate(delegate)
    }

    func configureIndicator(_ moving: Bool) {
        self.leftFakeIndicatorView.isHidden = moving
        self.rightFakeIndicatorView.isHidden = moving
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        let cellInterval: CGFloat = 1

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: cellInterval,
                                           left: 0,
                                           bottom: cellInterval,
                                           right: 0)
        layout.minimumInteritemSpacing = cellInterval
        layout.minimumLineSpacing = cellInterval
        layout.sectionHeadersPinToVisibleBounds = true

        return layout
    }

    private func configureUI() {
        let twice: CGFloat = 2

        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        self.isDirectionalLockEnabled = true
        self.contentSize = CGSize(width: self.frame.width * twice, height: self.frame.height)
    }

    func configure(searchType: SearchType) {
        self.subviews.last?.alpha = 1
        self.delegate?.scrollViewWillBeginDragging?(self)
        UIView.animate(withDuration: TimeInterval(0.3), animations: {
            switch searchType {
            case .bus:
                self.setContentOffset(CGPoint.zero, animated: false)
            case .station:
                self.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
            }
        }, completion: {_ in
            self.delegate?.scrollViewDidEndDecelerating?(self)
        })
    }
    
    func reload() {
        self.busResultCollectionView.reloadData()
        self.stationResultCollectionView.reloadData()
    }

    func emptyNoticeActivate(type: SearchType, by onOff: Bool) {
        switch type {
        case .bus:
            self.emptyBusSearchResultNoticeView.isHidden = !onOff
        case .station:
            self.emptyStationSearchResultNoticeView.isHidden = !onOff
        }
    }
}
