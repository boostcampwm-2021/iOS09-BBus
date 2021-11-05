//
//  MovingStatusViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class MovingStatusViewController: UIViewController {
    
    enum Color {
        static let blueBus = UIColor.systemBlue
        static let white = UIColor.white
        static let black = UIColor.label
        static let border = UIColor.lightGray
        static let congestionLine = UIColor.systemGray
        static let clear = UIColor.clear
    }
    
    enum Image {
        static let booDuck = UIImage(named: "BooDuck")
        static let unfold = UIImage(systemName: "chevron.up")
        static let fold = UIImage(systemName: "chevron.down")
        static let getOn = UIImage(named: "GetOn")
        static let getOff = UIImage(named: "GetOff")
        static let waypoint = UIImage(named: "StationCenterCircle")
    }

    weak var coordinator: MovingStatusCoordinator?
    private lazy var movingStatusView = MovingStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureLayout()
        self.configureDelegate()
    }
    
    // MARK: - Configure
    private func configureLayout() {
        self.view.addSubview(self.movingStatusView)
        self.movingStatusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.movingStatusView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -80),
            self.movingStatusView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.movingStatusView
                .leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.movingStatusView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func configureDelegate() {
        self.movingStatusView.configureDelegate(self)
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
