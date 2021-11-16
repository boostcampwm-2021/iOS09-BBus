//
//  AlarmSettingViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit
import Combine

class AlarmSettingViewController: UIViewController {

    weak var coordinator: AlarmSettingCoordinator?
    private lazy var alarmSettingView = AlarmSettingView()
    private lazy var customNavigationBar = CustomNavigationBar()
    private lazy var refreshButton: UIButton = {
        let radius: CGFloat = 25

        let button = UIButton()
        button.setImage(BBusImage.refresh, for: .normal)
        button.layer.cornerRadius = radius
        button.tintColor = BBusColor.white
        button.backgroundColor = BBusColor.darkGray
        return button
    }()
    private let viewModel: AlarmSettingViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: AlarmSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureColor()
        self.configureLayout()
        self.configureDelegate()
        self.configureMOCKDATA()
        
        self.binding()
    }
    
    // MARK: - Configure
    private func configureLayout() {
        let refreshButtonWidthAnchor: CGFloat = 50
        let refreshTrailingBottomInterval: CGFloat = -16

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

        self.view.addSubview(self.refreshButton)
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.refreshButton.widthAnchor.constraint(equalToConstant: refreshButtonWidthAnchor),
            self.refreshButton.heightAnchor.constraint(equalToConstant: refreshButtonWidthAnchor),
            self.refreshButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: refreshTrailingBottomInterval),
            self.refreshButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: refreshTrailingBottomInterval)
        ])
    }

    private func configureDelegate() {
        self.alarmSettingView.configureDelegate(self)
        self.customNavigationBar.configureDelegate(self)
    }

    private func configureColor() {
        self.view.backgroundColor = BBusColor.white
        self.customNavigationBar.configureTintColor(color: BBusColor.black)
        self.customNavigationBar.configureAlpha(alpha: 1)
    }

    private func configureMOCKDATA() {
        self.customNavigationBar.configureTitle(NSAttributedString(string: "461 ∙ 예술인마을.사당초등학교"))
    }
    
    private func binding() {
        self.bindingBusArriveInfos()
    }
    
    private func bindingBusArriveInfos() {
        self.viewModel?.$busArriveInfos
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                self?.alarmSettingView.reload()
            })
            .store(in: &self.cancellables)
    }
}

// MARK: - DataSource: UITableView
extension AlarmSettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return AlarmSettingView.tableViewSectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.viewModel?.busArriveInfos.count ?? 0
        case 1:
            return 10
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GetOnStatusCell.reusableID, for: indexPath) as? GetOnStatusCell else { return UITableViewCell() }
            guard let info = self.viewModel?.busArriveInfos[indexPath.row] else { return cell }
            
            cell.configure(busColor: BBusColor.bbusTypeBlue)
            cell.configure(order: String(indexPath.row+1),
                           remainingTime: info.arriveRemainTime?.toString(),
                           remainingStationCount: info.relativePosition,
                           busCongestionStatus: info.congestion?.toString(),
                           arrivalTime: info.estimatedArrivalTime,
                           currentLocation: info.currentStation,
                           busNumber: info.plainNumber)
            cell.configureDelegate(self)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GetOffTableViewCell.reusableID, for: indexPath) as? GetOffTableViewCell else { return UITableViewCell() }
            
            cell.configure(beforeColor: indexPath.item == 0 ? .clear : BBusColor.bbusGray,
                           afterColor: indexPath.item == 9 ? .clear : BBusColor.bbusGray,
                           title: "신촌오거리.현대백화점",
                           description: "14062 | 2분 소요",
                           type: indexPath.item == 0 ? .getOn : .waypoint)
            cell.configureDelegate(self)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "승차알람"
        case 1:
            return "하차알람"
        default:
            return nil
        }
    }
}

// MARK: - Delegate : UITableView
extension AlarmSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return GetOnStatusCell.cellHeight
        case 1:
            return GetOffTableViewCell.cellHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.contentView.backgroundColor = BBusColor.white
        header.textLabel?.textColor = BBusColor.black
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AlarmSettingView.tableViewHeaderHeight
    }
}

// MARK: - Delegate : BackButton
extension AlarmSettingViewController: BackButtonDelegate {
    func touchedBackButton() {
        self.coordinator?.terminate()
    }
}

// MARK: - Delegate: GetOffAlarmButton
extension AlarmSettingViewController: GetOffAlarmButtonDelegate {
    func shouldGoToMovingStatusScene() {
        UIView.animate(withDuration: 0.3) {
            self.coordinator?.openMovingStatus()
        }
    }
}

// MARK: - Delegate: GetOnAlarmButton
extension AlarmSettingViewController: GetOnAlarmButtonDelegate {
    func toggleGetOnAlarmSetting() {
        print("toggle Alarm")
    }
}
