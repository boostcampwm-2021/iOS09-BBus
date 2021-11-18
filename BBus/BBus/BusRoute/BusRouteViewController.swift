//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit
import Combine

final class BusRouteViewController: UIViewController {

    weak var coordinator: BusRouteCoordinator?
    private lazy var customNavigationBar = CustomNavigationBar()
    private lazy var busRouteView = BusRouteView()
    private let viewModel: BusRouteViewModel?
    private var cancellables: Set<AnyCancellable> = []
    private var busTags: [BusTagView] = []
    private var busIcon: UIImage?

    private lazy var refreshButton: UIButton = {
        let radius: CGFloat = 25

        let button = UIButton()
        button.setImage(BBusImage.refresh, for: .normal)
        button.layer.cornerRadius = radius
        button.tintColor = BBusColor.white
        button.backgroundColor = BBusColor.darkGray

        button.addAction(UIAction(handler: { _ in
            self.viewModel?.refreshBusPos()
        }), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.binding()
        self.configureLayout()
        self.configureDelegate()
        self.configureBaseColor()
        self.fetch()
    }

    init(viewModel: BusRouteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    // MARK: - Configure
    private func configureLayout() {
        let refreshButtonWidthAnchor: CGFloat = 50
        let refreshTrailingBottomInterval: CGFloat = -16

        self.view.addSubview(self.busRouteView)
        self.busRouteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busRouteView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.busRouteView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.busRouteView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.busRouteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        self.view.addSubview(self.customNavigationBar)
        self.customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.customNavigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.customNavigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.customNavigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        self.busRouteView.configureTableViewHeight(count: 20)

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
        self.busRouteView.configureDelegate(self)
        self.customNavigationBar.configureDelegate(self)
    }

    private func configureBaseColor() {
        self.view.backgroundColor = BBusColor.gray
        self.customNavigationBar.configureBackgroundColor(color: BBusColor.gray)
        self.customNavigationBar.configureTintColor(color: BBusColor.white)
        self.customNavigationBar.configureAlpha(alpha: 0)
        self.busRouteView.configureColor(to: BBusColor.gray)
    }
    
    private func configureBusColor(type: RouteType) {
        let color: UIColor?

        switch type {
        case .mainLine:
            color = BBusColor.bbusTypeBlue
            self.busIcon = BBusImage.blueBusIcon
        case .broadArea:
            color = BBusColor.bbusTypeRed
            self.busIcon = BBusImage.redBusIcon
        case .customized:
            color = BBusColor.bbusTypeGreen
            self.busIcon = BBusImage.greenBusIcon
        case .circulation:
            color = BBusColor.bbusTypeCirculation
            self.busIcon = BBusImage.circulationBusIcon
        case .lateNight:
            color = BBusColor.bbusTypeBlue
            self.busIcon = BBusImage.blueBusIcon
        case .localLine:
            color = BBusColor.bbusTypeGreen
            self.busIcon = BBusImage.greenBusIcon
        }

        self.view.backgroundColor = color
        self.customNavigationBar.configureBackgroundColor(color: color)
        self.customNavigationBar.configureTintColor(color: BBusColor.white)
        self.customNavigationBar.configureAlpha(alpha: 0)
        self.busRouteView.configureColor(to: color)
    }

    private func configureBusTags(buses: [BusPosInfo]) {
        self.busTags.forEach { $0.removeFromSuperview() }
        self.busTags.removeAll()

        buses.forEach { bus in
            let tag = self.busRouteView.createBusTag(location: bus.location,
                                                     busIcon: self.busIcon,
                                                     busNumber: bus.number,
                                                     busCongestion: bus.congestion.toString(),
                                                     isLowFloor: bus.islower)
            self.busTags.append(tag)
        }
    }

    private func binding() {
        self.bindingBusRouteHeaderResult()
        self.bindingBusRouteBodyResult()
        self.bindingBusesPosInfo()
        self.bindingNetworkError()
    }

    private func bindingBusRouteHeaderResult() {
        self.viewModel?.$header
            .receive(on: BusRouteUsecase.queue)
            .sink(receiveValue: { [weak self] header in
                guard let header = header else { return }
                DispatchQueue.main.async {
                    self?.customNavigationBar.configureBackButtonTitle(header.busRouteName)
                    self?.busRouteView.configureHeaderView(busType: header.routeType.rawValue+"버스",
                                                          busNumber: header.busRouteName,
                                                          fromStation: header.startStation,
                                                          toStation: header.endStation)
                    self?.configureBusColor(type: header.routeType)
                }
            })
            .store(in: &self.cancellables)
    }

    private func bindingBusRouteBodyResult() {
        self.viewModel?.$bodys
            .receive(on: BusRouteUsecase.queue)
            .sink(receiveValue: { [weak self] bodys in
                DispatchQueue.main.async {
                    self?.busRouteView.reload()
                    self?.busRouteView.configureTableViewHeight(count: bodys.count)
                }
            })
            .store(in: &self.cancellables)
    }

    private func bindingBusesPosInfo() {
        self.viewModel?.$buses
            .receive(on: BusRouteUsecase.queue)
            .sink(receiveValue: { [weak self] buses in
                DispatchQueue.main.async {
                    self?.configureBusTags(buses: buses)
                }
            })
            .store(in: &self.cancellables)
    }
    
    private func bindingNetworkError() {
        self.viewModel?.usecase.$networkError
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                guard let _ = error else { return }
                self?.networkAlert()
            })
            .store(in: &self.cancellables)
    }

    private func networkAlert() {
        let controller = UIAlertController(title: "네트워크 장애", message: "네트워크 장애가 발생하여 앱이 정상적으로 동작되지 않습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        controller.addAction(action)
        self.coordinator?.delegate?.presentAlert(controller: controller, completion: nil)
    }
    
    private func fetch() {
        self.viewModel?.fetch()
    }
}

// MARK: - DataSource : TableView
extension BusRouteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.bodys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusRouteTableViewCell.reusableID, for: indexPath) as? BusRouteTableViewCell else { return UITableViewCell() }
        guard let bodys = self.viewModel?.bodys else { return cell }
        let stationInfo = bodys[indexPath.row]
        cell.configure(speed: stationInfo.speed,
                       afterSpeed: stationInfo.afterSpeed,
                       index: indexPath.row,
                       count: stationInfo.count,
                       title: stationInfo.title,
                       description: stationInfo.description,
                       type: stationInfo.transYn != "Y" ? .waypoint : .uturn)
        return cell
    }
}

// MARK: - Delegate : UITableView
extension BusRouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let stationInfo = self.viewModel?.bodys[indexPath.item] else { return }
        self.coordinator?.pushToStation(arsId: stationInfo.arsId)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BusRouteTableViewCell.cellHeight
    }
}

// MARK: - Delegate : UIScrollView
extension BusRouteViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let baseLineContentOffset = BusRouteHeaderView.headerHeight - CustomNavigationBar.height
        if scrollView.contentOffset.y >= baseLineContentOffset {
            self.customNavigationBar.configureAlpha(alpha: 1)
        }
        else {
            self.customNavigationBar.configureAlpha(alpha: CGFloat(scrollView.contentOffset.y/baseLineContentOffset))
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let animationBaselineOffset: CGFloat = 70
        let headerHeight: CGFloat = 127
        let headerTop: CGFloat = 0
        let animationDuration: TimeInterval = 0.05
        
        if scrollView.contentOffset.y >= animationBaselineOffset && scrollView.contentOffset.y < headerHeight {
            UIView.animate(withDuration: animationDuration) {
                scrollView.contentOffset.y = headerHeight
            }
        } else if scrollView.contentOffset.y > headerTop && scrollView.contentOffset.y < animationBaselineOffset {
            UIView.animate(withDuration: animationDuration) {
                scrollView.contentOffset.y = headerTop
            }
        }
    }
}

// MARK: - Delegate : BackButton
extension BusRouteViewController: BackButtonDelegate {
    func touchedBackButton() {
        self.coordinator?.terminate()
    }
}
