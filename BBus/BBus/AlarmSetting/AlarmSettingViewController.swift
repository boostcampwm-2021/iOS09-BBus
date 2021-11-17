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
    private lazy var refreshButton: ThrottleButton = {
        let radius: CGFloat = 25

        let button = ThrottleButton()
        button.setImage(BBusImage.refresh, for: .normal)
        button.layer.cornerRadius = radius
        button.tintColor = BBusColor.white
        button.backgroundColor = BBusColor.darkGray
        button.addTouchUpEventWithThrottle(delay: ThrottleButton.refreshInterval) {
            self.viewModel?.refresh()
        }
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
    
    private func binding() {
        self.bindingBusArriveInfos()
        self.bindingBusStationInfos()
    }
    
    private func bindingBusArriveInfos() {
        self.viewModel?.$busArriveInfos
            .throttle(for: .seconds(1), scheduler: AlarmSettingUseCase.queue, latest: true)
            .sink(receiveValue: { [weak self] data in
                DispatchQueue.main.async {
                    self?.alarmSettingView.reloadGetOnSection()
                }
            })
            .store(in: &self.cancellables)
    }
    
    private func bindingBusStationInfos() {
        self.viewModel?.$busStationInfos
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] infos in
                guard let self = self else { return }
                self.alarmSettingView.reload()
                if let viewModel = self.viewModel,
                   let stationName = infos.first?.name {
                    self.customNavigationBar.configureTitle(busName: viewModel.busName, stationName: stationName, routeType: viewModel.routeType)
                }
            })
            .store(in: &self.cancellables)
    }
    
    private func bindingErrorMessage() {
        self.viewModel?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] message in
                guard let message = message else { return }
                self?.alert(message: message)
            })
            .store(in: &self.cancellables)
    }
    
    private func alert(message: String) {
        let controller = UIAlertController()
        let action = UIAlertAction(title: message, style: .cancel, handler: nil)
        controller.addAction(action)
        self.coordinator?.delegate?.pushAlert(controller: controller, completion: nil)
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
            guard let info = self.viewModel?.busArriveInfos.first else { return 0 }
            return info.arriveRemainTime != nil ? (self.viewModel?.busArriveInfos.count ?? 0) : 1
        case 1:
            guard let info = self.viewModel?.busStationInfos else { return 0 }
            return info.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let info = self.viewModel?.busArriveInfos[indexPath.row] else { return UITableViewCell() }
            if (info.arriveRemainTime == nil && indexPath.row == 0) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NoneInfoTableViewCell.reusableID, for: indexPath) as? NoneInfoTableViewCell else { return UITableViewCell() }
                return cell
            }
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: GetOnStatusCell.reusableID, for: indexPath) as? GetOnStatusCell else { return UITableViewCell() }
                cell.configure(routeType: self.viewModel?.routeType)
                cell.configure(order: String(indexPath.row+1),
                               remainingTime: info.arriveRemainTime?.toString(),
                               remainingStationCount: info.relativePosition,
                               busCongestionStatus: info.congestion?.toString(),
                               arrivalTime: info.estimatedArrivalTime,
                               currentLocation: info.currentStation,
                               busNumber: info.plainNumber)
                cell.configureDelegate(self)
                return cell
            }
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GetOffTableViewCell.reusableID, for: indexPath) as? GetOffTableViewCell else { return UITableViewCell() }
            guard let infos = self.viewModel?.busStationInfos else { return cell }
            let info = infos[indexPath.item]
            
            cell.configure(beforeColor: indexPath.item == 0 ? .clear : BBusColor.bbusGray,
                           afterColor: indexPath.item == infos.count - 1 ? .clear : BBusColor.bbusGray,
                           title: info.name,
                           description: indexPath.item == 0 ? "\(info.arsId)" : "\(info.arsId) | \(info.estimatedTime)분 소요",
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
            guard let info = self.viewModel?.busArriveInfos[indexPath.row] else { return 0 }
            switch info.arriveRemainTime {
            case nil :
                return indexPath.row == 0 ? NoneInfoTableViewCell.height : GetOnStatusCell.singleInfoCellHeight
            default :
                return GetOnStatusCell.infoCellHeight
            }
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
    func shouldGoToMovingStatusScene(from cell: UITableViewCell) {
        guard let busRouteId = self.viewModel?.busRouteId,
              let indexPath = self.alarmSettingView.indexPath(for: cell),
              let startStationArsId = self.viewModel?.busStationInfos.first?.arsId,
              let endStationArsId = self.viewModel?.busStationInfos[indexPath.item].arsId else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.coordinator?.openMovingStatus(busRouteId: busRouteId, fromArsId: startStationArsId, toArsId: endStationArsId)
        }
    }
}

// MARK: - Delegate: GetOnAlarmButton
extension AlarmSettingViewController: GetOnAlarmButtonDelegate {
    func toggleGetOnAlarmSetting(for cell: UITableViewCell, cancel: Bool) -> Bool? {
        guard let indexPath = self.alarmSettingView.indexPath(for: cell),
              let arriveInfo = self.viewModel?.busArriveInfos[indexPath.item],
              let remainTime = arriveInfo.arriveRemainTime?.toString() else { return nil }
        if let count = Int(String(arriveInfo.relativePosition?.first ?? "0")),
           count <= 1 {
            let arrivingSoonMessage = "버스가 곧 도착합니다"
            self.alert(message: arrivingSoonMessage)
            return false
        }
        else {
            print("\(arriveInfo.plainNumber) 버스 승차알람을 \(cancel ? "취소" : "설정")하였습니다.")
            if !cancel { print("약 \(remainTime) 후 도착 예정입니다.") }
            return true
        }
    }
}
