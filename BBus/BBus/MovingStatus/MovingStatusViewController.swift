//
//  MovingStatusViewController.swift
//  BBus
//
//  Created by Minsang on 2021/11/15.
//

import UIKit
import Combine

typealias MovingStatusCoordinator = MovingStatusOpenCloseDelegate & MovingStatusFoldUnfoldDelegate

class MovingStatusViewController: UIViewController {

    weak var coordinator: MovingStatusCoordinator?
    private lazy var movingStatusView = MovingStatusView()
    private let viewModel: MovingStatusViewModel?
    private var cancellables: Set<AnyCancellable> = []

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
    }
    
    private func configureDelegate() {
        self.movingStatusView.configureDelegate(self)
    }
    
    private func configureBusTag() {
        self.movingStatusView.addBusTag()
    }
    
    private func configureColor() {
        self.view.backgroundColor = BBusColor.white
    }

    private func binding() {
        self.bindingHeaderBusName()
    }

    private func bindingHeaderBusName() {
        self.viewModel?.$busName
            .receive(on: MovingStatusUsecase.queue)
            .sink(receiveValue: { busName in
                guard let busName = busName else { return }
                DispatchQueue.main.async {
                    self.movingStatusView.configureBusName(to: busName)
                }
            })
            .store(in: &self.cancellables)
    }

    private func fetch() {
        self.viewModel?.fetch()
    }
}

// MARK: - DataSource: UITableView
extension MovingStatusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovingStatusTableViewCell.reusableID, for: indexPath) as? MovingStatusTableViewCell else { return UITableViewCell() }

        switch indexPath.item {
        case 0:
            cell.configure(type: .getOn)
        case 9:
            cell.configure(type: .getOff)
        default:
            cell.configure(type: .waypoint)
        }
        
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
