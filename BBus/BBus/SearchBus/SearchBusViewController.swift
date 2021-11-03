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
        self.view.backgroundColor = UIColor.systemBackground
        self.title = "SearchBus"
        self.navigationItem.titleView = self.searchTextField
        self.configureLayout()
        self.searchBusView.configureReusableCell()
        self.searchBusView.configureLayout()
        self.searchBusView.configureDelegate(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.coordinator?.terminate()
        }
    }
    
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
}

extension SearchBusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "bbusGray")
        view.backgroundView = backgroundView
        return view
    }
}

extension SearchBusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section % 2 == 0) ? "경기" : "부산"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.configureUI(title: "15", detailInfo: "가평군 일반버스")
        cell.configureLayout()
        return cell
    }
}

