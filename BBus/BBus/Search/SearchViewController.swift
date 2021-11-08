//
//  SearchBusViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class SearchViewController: UIViewController {

    weak var coordinator: SearchCoordinator?
    private lazy var searchBusView = SearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.configureUI()
        self.searchBusView.configureDelegate(self)
        self.configureDelegate()
    }

    // MARK: - Configuration
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBusView.configureInitialTabStatus(type: .bus)
    }

    private func configureDelegate() {
        self.searchBusView.configureBackButtonDelegate(self)
    }

    private func configureLayout() {
        self.view.addSubview(self.searchBusView)
        self.searchBusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchBusView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.searchBusView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.searchBusView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.searchBusView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func configureUI() {
        self.view.backgroundColor = MyColor.white
    }
}

extension SearchViewController: SearchBackButtonDelegate {
    func shouldNavigationPop() {
        self.coordinator?.terminate()
    }
}

// MARK: - Delegate : UICollectionView
extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.searchBusView.currentSearchType == SearchType.bus {
            self.coordinator?.pushToBusRoute()
        }
        else {
            self.coordinator?.pushToStation()
        }
    }
}

// MARK: - DataSource : UICollectionView
extension SearchViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleCollectionHeaderView.identifier, for: indexPath) as? SimpleCollectionHeaderView else { return UICollectionReusableView() }
        header.configureLayout()
        header.configure(title: (indexPath.section % 2 == 0) ? "경기" : "부산")
        return header
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        if collectionView.frame.origin.x == 0 {
            cell.configureUI(title: "15", detailInfo: NSMutableAttributedString(string: "가평군 일반버스"))
        }
        else {
            let fullText = "14911 | 공항철도.홍대입구역 방면"
            let range = (fullText as NSString).range(of: "|")
            let attributedString = NSMutableAttributedString(string: fullText)
            attributedString.addAttribute(.foregroundColor,
                                          value: MyColor.bbusLightGray as Any,
                                          range: range)
            cell.configureUI(title: "홍대입구", detailInfo: attributedString)
        }
        cell.configureLayout()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBusView.hideKeyboard()
    }
}

// MARK: - DelegateFlowLayout : UICollectionView
extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: SearchResultCollectionViewCell.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: SimpleCollectionHeaderView.height)
    }
}
