//
//  SearchBusViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    weak var coordinator: SearchCoordinator?
    private lazy var searchView = SearchView()
    private let viewModel: SearchViewModel?
    private var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLayout()
        self.configureUI()
        self.configureDelegate()
        self.binding()
    }

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    // MARK: - Configuration
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchView.configureInitialTabStatus(type: .bus)
    }

    private func configureDelegate() {
        self.searchView.configureBackButtonDelegate(self)
        self.searchView.configureDelegate(self)
    }

    private func configureLayout() {
        self.view.addSubview(self.searchView)
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.searchView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.searchView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.searchView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func configureUI() {
        self.view.backgroundColor = BBusColor.white
    }
    
    private func binding() {
        self.cancellable = self.viewModel?.$searchResults
            .receive(on: SearchUseCase.queue)
            .sink(receiveValue: { _ in
                DispatchQueue.main.async {
                    self.searchView.reload()
                }
            })
    }
}

// MARK: - Delegate : SearchBackButton
extension SearchViewController: SearchBackButtonDelegate {
    func shouldNavigationPop() {
        self.coordinator?.terminate()
    }
}

// MARK: - Delegate : UICollectionView
extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.searchView.currentSearchType == SearchType.bus {
            guard let busRouteId = self.viewModel?.searchResults.busSearchResults[indexPath.row].routeID else { return }
            self.coordinator?.pushToBusRoute(busRouteId: busRouteId)
        }
        else {
            guard let arsId = self.viewModel?.searchResults.stationSearchResults[indexPath.row].arsId else { return }
            self.coordinator?.pushToStation(arsId: arsId)
        }
    }
}

// MARK: - DataSource : UICollectionView
extension SearchViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let regionCount = 1
        
        if collectionView.frame.origin.x == 0 {
            return self.viewModel?.searchResults.busSearchResults.count == 0 ? 0 : regionCount
        }
        else {
            return self.viewModel?.searchResults.stationSearchResults.count == 0 ? 0 : regionCount
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.frame.origin.x == 0 {
            return self.viewModel?.searchResults.busSearchResults.count ?? 0
        }
        else {
            return self.viewModel?.searchResults.stationSearchResults.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleCollectionHeaderView.identifier, for: indexPath) as? SimpleCollectionHeaderView else { return UICollectionReusableView() }
        
        header.configureLayout()
        header.configure(title: "서울")
        
        return header
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView.frame.origin.x == 0 {
            guard let bus = self.viewModel?.searchResults.busSearchResults[indexPath.row] else { return UICollectionViewCell() }
            cell.configureBusUI(title: bus.busRouteName, detailInfo: bus.routeType)
        }
        else {
            guard let station = self.viewModel?.searchResults.stationSearchResults[indexPath.row] else { return UICollectionViewCell() }
            cell.configureStationUI(title: station.stationName,
                                    titleMatchRanges: station.stationNameMatchRanges,
                                    arsId: station.arsId,
                                    arsIdMatchRanges: station.arsIdMatchRanges)
        }
        
        cell.configureLayout()
        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchView.hideKeyboard()
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

// MARK: - Delegate : TextField
extension SearchViewController: TextFieldDelegate {
    func shouldRefreshSearchResult(by keyword: String) {
        self.viewModel?.configure(keyword: keyword)
    }
}
