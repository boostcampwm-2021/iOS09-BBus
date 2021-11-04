//
//  AlarmSettingViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class AlarmSettingViewController: UIViewController {

    enum Color {
        static let white = UIColor.white
        static let black = UIColor.black
        static let clear = UIColor.clear
        static let red = UIColor.red
        static let lightGray = UIColor.lightGray
        static let darkGray = UIColor.darkGray
        static let blueBus = UIColor.systemBlue
        static let tableViewSeperator = UIColor.systemGray6
        static let tableViewCellSubTitle = UIColor.systemGray
        static let tagBusNumber = UIColor.darkGray
        static let tagBusCongestion = UIColor.red
        static let greenLine = UIColor.green
        static let redLine = UIColor.red
        static let tableBackground = UIColor.systemGray5
    }

    enum Image {
        static let clockIcon = UIImage(systemName: "clock")
        static let locationIcon = UIImage(named: "locationIcon")
        static let busIcon = UIImage(named: "grayBusIcon")
        static let alarmIcon = UIImage(systemName: "alarm")
    }

    weak var coordinator: AlarmSettingCoordinator?
    private lazy var alarmSettingView = AlarmSettingView()
    private lazy var customNavigationBar = CustomNavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.white
        self.navigationController?.isNavigationBarHidden = true
        self.configureLayout()
        self.configureDelegate()
        self.configureTableView()
        self.configureColor()
        self.configureMOCKDATA()
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            self.coordinator?.terminate()
        }
    }

    private func configureTableView() {
        self.alarmSettingView.alarmTableView.delegate = self
        self.alarmSettingView.alarmTableView.dataSource = self
    }

    private func configureLayout() {
        self.view.addSubview(self.customNavigationBar)
        self.customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.customNavigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.customNavigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.customNavigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        self.view.addSubview(self.alarmSettingView)
        self.alarmSettingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmSettingView.topAnchor.constraint(equalTo: self.customNavigationBar.bottomAnchor),
            self.alarmSettingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.alarmSettingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.alarmSettingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    private func configureDelegate() {
        self.alarmSettingView.configureDelegate(self)
        self.customNavigationBar.configureDelegate(self)
    }

    private func configureColor() {
        self.customNavigationBar.configureTintColor(color: Color.black)
        self.customNavigationBar.configureAlpha(alpha: 1)
    }

    private func configureMOCKDATA() {
        self.customNavigationBar.configureTitle(NSAttributedString(string: "461 ∙ 예술인마을.사당초등학교"))
    }
}

extension AlarmSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GetOnStatusCell.reusableID, for: indexPath) as? GetOnStatusCell else { return UITableViewCell() }

        cell.configure(busColor: Color.blueBus)
        cell.configure(order: String(indexPath.row+1),
                       remainingTime: "2분 18초",
                       remainingStationCount: "2번째",
                       busCongestionStatus: "여유",
                       arrivalTime: "오후 04시 11분 도착 예정",
                       currentLocation: "낙성대입구",
                       busNumber: "서울74사3082")

        return cell
    }
}

extension AlarmSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GetOnStatusCell.cellHeight
    }
}

extension AlarmSettingViewController: BackButtonDelegate {
    func touchedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
