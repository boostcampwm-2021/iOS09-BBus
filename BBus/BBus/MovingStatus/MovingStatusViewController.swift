//
//  MovingStatusViewController.swift
//  BBus
//
//  Created by Minsang on 2021/11/15.
//

import UIKit
import Combine
import CoreLocation

typealias MovingStatusCoordinator = MovingStatusOpenCloseDelegate & MovingStatusFoldUnfoldDelegate & AlertCreateDelegate

final class MovingStatusViewController: UIViewController {

    weak var coordinator: MovingStatusCoordinator?
    private lazy var movingStatusView = MovingStatusView()
    private let viewModel: MovingStatusViewModel?
    private var cancellables: Set<AnyCancellable> = []
    private var busTag: MovingStatusBusTagView?
    private var color: UIColor?
    private var busIcon: UIImage?
    private var locationManager: CLLocationManager?

    private lazy var refreshButton: ThrottleButton = {
        let radius: CGFloat = 25

        let button = ThrottleButton()
        button.setImage(BBusImage.refresh, for: .normal)
        button.layer.cornerRadius = radius
        button.tintColor = BBusColor.white
        button.backgroundColor = BBusColor.darkGray

        button.addTouchUpEventWithThrottle(delay: ThrottleButton.refreshInterval) {
            self.viewModel?.updateAPI()
        }
        return button
    }()

    init(viewModel: MovingStatusViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.binding()
        self.configureLayout()
        self.configureDelegate()
        self.configureBusTag()
        self.fetch()
        self.configureLocationManager()
    }

    private func configureLocationManager() {
        // locationManager 인스턴스를 생성
        self.locationManager = CLLocationManager()

        // 앱을 사용할 때만 위치 정보를 허용할 경우 호출
        self.locationManager?.requestWhenInUseAuthorization()

        // 위치 정보 제공의 정확도를 설정할 수 있다.
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        // 백그라운드에서 위치 업데이트
//        self.locationManager?.allowsBackgroundLocationUpdates = true

        // 위치 정보를 지속적으로 받고 싶은 경우 이벤트를 시작
        self.locationManager?.startUpdatingLocation()

        self.locationManager?.delegate = self
    }
    
    // MARK: - Configure
    private func configureLayout() {
        self.view.addSubview(self.movingStatusView)
        self.movingStatusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.movingStatusView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.movingStatusView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.movingStatusView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.movingStatusView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        let refreshButtonWidthAnchor: CGFloat = 50
        let refreshBottomInterval: CGFloat = -MovingStatusView.endAlarmViewHeight
        let refreshTrailingInterval: CGFloat = -16

        self.view.addSubview(self.refreshButton)
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.refreshButton.widthAnchor.constraint(equalToConstant: refreshButtonWidthAnchor),
            self.refreshButton.heightAnchor.constraint(equalToConstant: refreshButtonWidthAnchor),
            self.refreshButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: refreshTrailingInterval),
            self.refreshButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: refreshBottomInterval)
        ])
    }
    
    private func configureDelegate() {
        self.movingStatusView.configureDelegate(self)
    }
    
    private func configureColor() {
        self.view.backgroundColor = BBusColor.white
    }

    private func configureBusTag(bus: BoardedBus? = nil) {
        self.busTag?.removeFromSuperview()

        if let bus = bus {
            self.busTag = self.movingStatusView.createBusTag(location: bus.location,
                                                             color: self.color,
                                                             busIcon: self.busIcon,
                                                             remainStation: bus.remainStation)
        }
        else {
            self.busTag = self.movingStatusView.createBusTag(color: self.color,
                                                             busIcon: self.busIcon,
                                                             remainStation: nil)
        }
    }

    private func binding() {
        self.bindHeaderBusInfo()
        self.bindRemainTime()
        self.bindCurrentStation()
        self.bindStationInfos()
        self.bindBoardedBus()
    }

    private func bindHeaderBusInfo() {
        self.viewModel?.$busInfo
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { [weak self] busInfo in
                guard let busInfo = busInfo else { return }
                DispatchQueue.main.async {
                    self?.movingStatusView.configureBusName(to: busInfo.busName)
                    self?.configureBusColor(type: busInfo.type)
                    self?.configureBusTag(bus: nil)
                }
            })
            .store(in: &self.cancellables)
    }

    private func bindRemainTime() {
        self.viewModel?.$remainingTime
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { [weak self] remainingTime in
                DispatchQueue.main.async {
                    self?.movingStatusView.configureHeaderInfo(remainStation: self?.viewModel?.remainingStation, remainTime: remainingTime)
                }
            })
            .store(in: &self.cancellables)
    }

    private func bindCurrentStation() {
        self.viewModel?.$remainingStation
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { [weak self] currentStation in
                DispatchQueue.main.async {
                    self?.movingStatusView.configureHeaderInfo(remainStation: currentStation, remainTime: self?.viewModel?.remainingTime)
                }
            })
            .store(in: &self.cancellables)
    }

    private func bindStationInfos() {
        self.viewModel?.$stationInfos
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.movingStatusView.reload()
                }
            })
            .store(in: &self.cancellables)
    }

    private func bindBoardedBus() {
        self.viewModel?.$boardedBus
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { [weak self] boardedBus in
                DispatchQueue.main.async {
                    self?.configureBusTag(bus: boardedBus)
                }
            })
            .store(in: &self.cancellables)
    }

    private func configureBusColor(type: RouteType) {
        switch type {
        case .mainLine:
            self.color = BBusColor.bbusTypeBlue
            self.busIcon = BBusImage.blueBooduckBus
        case .broadArea:
            self.color = BBusColor.bbusTypeRed
            self.busIcon = BBusImage.redBooduckBus
        case .customized:
            self.color = BBusColor.bbusTypeGreen
            self.busIcon = BBusImage.greenBooduckBus
        case .circulation:
            self.color = BBusColor.bbusTypeCirculation
            self.busIcon = BBusImage.circulationBooduckBus
        case .lateNight:
            self.color = BBusColor.bbusTypeBlue
            self.busIcon = BBusImage.blueBooduckBus
        case .localLine:
            self.color = BBusColor.bbusTypeGreen
            self.busIcon = BBusImage.greenBooduckBus
        }

        self.movingStatusView.configureColor(to: color)
    }

    private func fetch() {
        self.viewModel?.fetch()
    }
}

// MARK: - DataSource: UITableView
extension MovingStatusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.stationInfos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovingStatusTableViewCell.reusableID, for: indexPath) as? MovingStatusTableViewCell else { return UITableViewCell() }
        guard let stationInfo = self.viewModel?.stationInfos[indexPath.row] else { return cell }

        cell.configure(speed: stationInfo.speed,
                       afterSpeed: stationInfo.afterSpeed,
                       index: indexPath.row,
                       count: stationInfo.count,
                       title: stationInfo.title)
        
        return cell
    }
}

// MARK: - Delegate : UITableView
extension MovingStatusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GetOffTableViewCell.cellHeight
    }
}

// MARK: - Delegate : BottomIndicatorButton
extension MovingStatusViewController: BottomIndicatorButtonDelegate {
    func shouldUnfoldMovingStatusView() {
        // Coordinator에게 Unfold 요청
        print("bottom indicator button is touched")
        UIView.animate(withDuration: 0.3) {
            self.coordinator?.unfold()
        }
    }
}

// MARK: - Delegate : BottomIndicatorButton
extension MovingStatusViewController: FoldButtonDelegate {
    func shouldFoldMovingStatusView() {
        // Coordinator에게 fold 요청
        print("fold button is touched")
        UIView.animate(withDuration: 0.3) {
            self.coordinator?.fold()
        }
    }
}

// MARK: - Delegate : EndAlarmButton
extension MovingStatusViewController: EndAlarmButtonDelegate {
    func shouldEndAlarm() {
        // alarm 종료
        print("end the alarm")
        self.coordinator?.close()
    }
}

// MARK: - Delegate: CLLocation
extension MovingStatusViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            self.viewModel?.findBoardBus(gpsY: Double(coordinate.latitude), gpsX: Double(coordinate.longitude))
        }
    }
}
