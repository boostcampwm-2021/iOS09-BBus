//
//  SearchBusView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

enum SearchType {
    case bus, station
}

class SearchView: UIView {

    private lazy var searchResultScrollView = SearchResultScrollView()
    private lazy var navigationView: SearchNavigationView = {
        let view = SearchNavigationView()
        view.backgroundColor = MyColor.white
        return view
    }()
    private(set) var currentSearchType: SearchType = .bus {
        didSet(beforeType) {
            self.navigationView.configure(searchType: self.currentSearchType)
            if self.isScrollViewHorizontalDragging() {
                DispatchQueue.main.async {
                    self.searchResultScrollView.configure(searchType: self.currentSearchType)
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
        self.configureTabButtonDelegate()
        self.searchResultScrollView.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
        self.configureTabButtonDelegate()
        self.searchResultScrollView.configureLayout()
    }

    convenience init() {
        self.init(frame: CGRect())
    }

    // MARK: - Configuration
    private func configureLayout() {
        let navigationViewHeight: CGFloat = 100

        self.addSubview(self.navigationView)
        self.navigationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.navigationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.navigationView.heightAnchor.constraint(equalToConstant: navigationViewHeight),
            self.navigationView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        self.addSubview(self.searchResultScrollView)
        self.searchResultScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchResultScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.searchResultScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.searchResultScrollView.topAnchor.constraint(equalTo: self.navigationView.bottomAnchor),
            self.searchResultScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func configureDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource & SearchBackButtonDelegate) {
        self.navigationView.configureBackButtonDelegate(delegate)
        self.searchResultScrollView.configureDelegate(delegate)
        self.searchResultScrollView.delegate = self
    }

    func configureInitialTabStatus(type: SearchType) {
        self.currentSearchType = type
    }

    func configureBackButtonDelegate(_ delegate: SearchBackButtonDelegate) {
        self.navigationView.configureBackButtonDelegate(delegate)
    }

    private func configureTabButtonDelegate() {
        self.navigationView.configureTabButtonDelegate(self)
    }

    func hideKeyboard() {
        self.navigationView.hideKeyboard()
    }
    
    func isScrollViewHorizontalDragging() -> Bool {
        return self.searchResultScrollView.contentOffset.x.remainder(dividingBy: self.searchResultScrollView.frame.width) == 0
    }
}

extension SearchView: BusTabButtonDelegate & StationTabButtonDelegate {

    func shouldBusTabSelect() {
        guard self.currentSearchType == SearchType.station else { return }
        self.currentSearchType = SearchType.bus
    }

    func shouldStationTabSelect() {
        guard self.currentSearchType == SearchType.bus else { return }
        self.currentSearchType = SearchType.station
    }
}

extension SearchView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO: Bug Fix
        guard !self.isScrollViewHorizontalDragging() else { return }
        self.currentSearchType = scrollView.contentOffset.x > scrollView.frame.width / 2 ? SearchType.station : SearchType.bus
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let scrollView = (scrollView as? SearchResultScrollView),
              let indicator = scrollView.subviews.last?.subviews.first else { return }

        let twice: CGFloat = 2
        let indicatorWidthPadding: CGFloat = 5

        scrollView.configureIndicator(true)
        scrollView.horizontalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: -indicatorWidthPadding, bottom: scrollView.frame.height - (SearchResultScrollView.indicatorHeight * twice), right: -indicatorWidthPadding)
        indicator.layer.cornerRadius = 0
        indicator.backgroundColor = MyColor.bbusTypeRed
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let scrollView = (scrollView as? SearchResultScrollView) else { return }
        scrollView.configureIndicator(false)
    }
}
