//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit
import Combine

final class BusRouteViewController: UIViewController, BaseViewControllerType {
    
    weak var coordinator: BusRouteCoordinator?
    private let viewModel: BusRouteViewModel?
    private lazy var busRouteView = BusRouteView()
    
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: BusRouteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseViewDidLoad()

        self.busRouteView.startLoader()
        self.configureBaseColor()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.baseViewWillAppear()
        
        self.viewModel?.configureObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel?.cancelObserver()
    }

    // MARK: - Configure
    func configureLayout() {
        self.view.addSubviews(self.busRouteView)

        NSLayoutConstraint.activate([
            self.busRouteView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.busRouteView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.busRouteView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.busRouteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        self.busRouteView.configureTableViewHeight(count: 20)
    }

    func configureDelegate() {
        self.busRouteView.configureDelegate(self)
    }
    
    func refresh() {
        self.viewModel?.refreshBusPos()
    }
    
    func bindAll() {
        self.bindLoader()
        self.bindBusRouteHeaderResult()
        self.bindBusRouteBodyResult()
        self.bindBusesPosInfo()
        self.bindNetworkError()
    }

    private func configureBaseColor() {
        self.view.backgroundColor = BBusColor.gray
        self.busRouteView.configureColor(to: BBusColor.gray)
    }

    private func bindBusRouteHeaderResult() {
        self.viewModel?.$header
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] header in
                if let header = header {
                    self?.busRouteView.configureBackButtonTitle(title: header.busRouteName)
                    self?.busRouteView.configureHeaderView(busType: header.routeType.rawValue+"버스",
                                                          busNumber: header.busRouteName,
                                                          fromStation: header.startStation,
                                                          toStation: header.endStation)
                    self?.view.backgroundColor = self?.busRouteView.configureBusColor(type: header.routeType)
                }
            })
            .store(in: &self.cancellables)
    }

    private func bindBusRouteBodyResult() {
        self.viewModel?.$bodys
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] bodys in
                self?.busRouteView.reload()
                self?.busRouteView.configureTableViewHeight(count: bodys.count)
            })
            .store(in: &self.cancellables)
    }

    private func bindBusesPosInfo() {
        self.viewModel?.$buses
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] buses in
                guard let viewModel = self?.viewModel else { return }

                self?.busRouteView.configureBusTags(buses: buses)

                if viewModel.stopLoader {
                    self?.busRouteView.stopLoader()
                }
            })
            .store(in: &self.cancellables)
    }
    
    private func bindNetworkError() {
        self.viewModel?.$networkError
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                guard let _ = error else { return }
                self?.networkAlert()
            })
            .store(in: &self.cancellables)
    }

    private func bindLoader() {
        self.viewModel?.$stopLoader
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isStop in
                if isStop {
                    self?.busRouteView.stopLoader()
                }
            })
            .store(in: &self.cancellables)
    }

    private func networkAlert() {
        let controller = UIAlertController(title: "네트워크 장애", message: "네트워크 장애가 발생하여 앱이 정상적으로 동작되지 않습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        controller.addAction(action)
        self.coordinator?.delegate?.presentAlertToNavigation(controller: controller, completion: nil)
    }
    
    private func noInfoAlert() {
        let controller = UIAlertController(title: "버스 에러",
                                           message: "죄송합니다. 현재 정보가 제공되지 않는 버스입니다.",
                                           preferredStyle: .alert)
        let action = UIAlertAction(title: "확인",
                                   style: .default,
                                   handler: { [weak self] _ in self?.coordinator?.terminate() })
        controller.addAction(action)
        self.coordinator?.delegate?.presentAlertToNavigation(controller: controller, completion: nil)
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
            self.busRouteView.configureNavigationAlpha(alpha: 1)
        }
        else {
            self.busRouteView.configureNavigationAlpha(alpha: CGFloat(scrollView.contentOffset.y/baseLineContentOffset))
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

// MARK: - Delegate: RefreshButton
extension BusRouteViewController: RefreshButtonDelegate {
    func buttonTapped() {
        self.refresh()
    }
}
