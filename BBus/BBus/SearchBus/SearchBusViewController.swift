//
//  SearchBusViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class SearchBusViewController: UIViewController {

    private lazy var searchTextField: UITextField = {
        let textField = UITextField(frame: CGRect(origin: CGPoint(), size: CGSize(width: self.view.frame.width - (self.navigationItem.leftBarButtonItem?.width ?? 0), height: 30)))
        textField.placeholder = "버스 입력"
        textField.backgroundColor = UIColor.gray
        return textField
    }()
    private lazy var searchBusView = SearchBusView()
    weak var coordinator: SearchBusCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.configureUI()
        self.searchBusView.configureLayout()
        self.searchBusView.configureDelegate(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.coordinator?.terminate()
        }
    }
    
    // MARK: - Configuration
    private func configureLayout() {
        self.searchBusView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.searchBusView)
        NSLayoutConstraint.activate([
            self.searchBusView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.searchBusView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.searchBusView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.searchBusView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor.white
    }
}

// MARK: - Delegate : UICollectionView
extension SearchBusViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.searchBusView.page {
            self.coordinator?.pushToBusRoute()
        }
        else {
            self.coordinator?.pushToStation()
        }
    }
}

// MARK: - DataSource : UICollectionView
extension SearchBusViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultHeaderView.identifier, for: indexPath) as? SearchResultHeaderView else { return UICollectionReusableView() }
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
                                          value: UIColor(named: "bbusLightGray") as Any,
                                          range: range)
            cell.configureUI(title: "홍대입구", detailInfo: attributedString)
        }
        cell.configureLayout()
        return cell
    }
}

// MARK: - DelegateFlowLayout : UICollectionView
extension SearchBusViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: SearchResultCollectionViewCell.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: SearchResultHeaderView.height)
    }
}
