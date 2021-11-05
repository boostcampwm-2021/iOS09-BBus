//
//  MovingStatusView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class MovingStatusView: UIView {
    
    private lazy var bottomIndicatorView = UIView()
    private lazy var bottomIndicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MovingStatusViewController.Image.booDuck
        return imageView
    }()
    private lazy var bottomIndicatorLabel: UILabel = {
        let labelFontSize: CGFloat = 15
        
        let label = UILabel()
        label.textColor = MovingStatusViewController.Color.white
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        label.text = "현위치 탐색중, 19분 소요예정"
        return label
    }()
    private lazy var unfoldButton: UIButton = {
        let button = UIButton()
        button.tintColor = MovingStatusViewController.Color.white
        button.setImage(MovingStatusViewController.Image.unfold, for: .normal)
        return button
    }()
    private lazy var headerView = UIView()
    private lazy var headerBottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = MovingStatusViewController.Color.border
        return view
    }()
    private lazy var busNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 27
        
        let label = UILabel()
        label.textColor = MovingStatusViewController.Color.blueBus
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        label.text = "700"
        return label
    }()
    private lazy var alarmStatusLabel: UILabel = {
        let labelFontSize: CGFloat = 14
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.text = "현위치 탐색중, 19분 소요예정"
        return label
    }()
    private lazy var foldButton: UIButton = {
        let button = UIButton()
        button.tintColor = MovingStatusViewController.Color.black
        button.setImage(MovingStatusViewController.Image.fold, for: .normal)
        return button
    }()
    private lazy var stationsTableView: UITableView = {
        let tableViewContentTopInset: CGFloat = 10
        let tableViewleftBottomRightInset: CGFloat = 0
        
        let tableView = UITableView()
        tableView.register(MovingStatusTableViewCell.self, forCellReuseIdentifier: MovingStatusTableViewCell.reusableID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = MovingStatusViewController.Color.white
        tableView.contentInset = UIEdgeInsets(top: tableViewContentTopInset,
                                              left: tableViewleftBottomRightInset,
                                              bottom: tableViewleftBottomRightInset,
                                              right: tableViewleftBottomRightInset)
        return tableView
    }()
    private lazy var endAlarmView = UIView()
    private lazy var endAlarmLabel: UILabel = {
        let labelFontSize: CGFloat = 18
        
        let label = UILabel()
        label.textColor = MovingStatusViewController.Color.white
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        label.text = "알람 종료"
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.configureLayout()
        self.bottomIndicatorView.backgroundColor = MovingStatusViewController.Color.blueBus
        self.headerView.backgroundColor = MovingStatusViewController.Color.white
        self.endAlarmView.backgroundColor = MovingStatusViewController.Color.blueBus
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureLayout()
        self.bottomIndicatorView.backgroundColor = MovingStatusViewController.Color.blueBus
        self.headerView.backgroundColor = MovingStatusViewController.Color.white
        self.endAlarmView.backgroundColor = MovingStatusViewController.Color.blueBus
    }

    private func configureLayout() {
        let bottomIndicatorImageViewSize: CGFloat = 25
        let bottomIndicatorImgaeViewTopMargin: CGFloat = 13
        let bottomIndicatorImageViewLeftMargin: CGFloat = 25
        let bottomIndicatorLabelRightMargin: CGFloat = -20
        let bottomIndicatorLabelLeftMargin: CGFloat = 10
        let foldUnfoldButtonRightMargin: CGFloat = -20
        let foldUnfoldButtonWidth: CGFloat = 30
        let foldUnfoldButtonHeight: CGFloat = 22
        let bottomIndicatorAndEndAlarmViewHeight: CGFloat = 80
        let headerHeight: CGFloat = 120
        let headerBottomBorderHeight: CGFloat = 0.5
        let busNumberLabelTopMargin: CGFloat = 45
        let busNumberLabelLeftMargin: CGFloat = 40
        let busNumberLabelRightMargin: CGFloat = -40
        let alarmStatusLabelTopMargin: CGFloat = 4
        let alarmStatusLabelRightMargin: CGFloat = -50
        let endAlarmLabelTopMargin: CGFloat = 13
        
        self.addSubview(self.bottomIndicatorView)
        self.bottomIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.bottomIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomIndicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bottomIndicatorView.heightAnchor.constraint(equalToConstant: bottomIndicatorAndEndAlarmViewHeight)
        ])
        
        self.bottomIndicatorView.addSubview(self.bottomIndicatorImageView)
        self.bottomIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomIndicatorImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: bottomIndicatorImgaeViewTopMargin),
            self.bottomIndicatorImageView.heightAnchor.constraint(equalToConstant: bottomIndicatorImageViewSize),
            self.bottomIndicatorImageView.widthAnchor.constraint(equalTo: self.bottomIndicatorImageView.heightAnchor),
            self.bottomIndicatorImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: bottomIndicatorImageViewLeftMargin)
        ])
        
        self.bottomIndicatorView.addSubview(self.unfoldButton)
        self.unfoldButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.unfoldButton.centerYAnchor.constraint(equalTo: self.bottomIndicatorImageView.centerYAnchor),
            self.unfoldButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: foldUnfoldButtonRightMargin),
            self.unfoldButton.heightAnchor.constraint(equalToConstant: foldUnfoldButtonHeight),
            self.unfoldButton.widthAnchor.constraint(equalToConstant: foldUnfoldButtonWidth)
        ])
        
        self.bottomIndicatorView.addSubview(self.bottomIndicatorLabel)
        self.bottomIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomIndicatorLabel.centerYAnchor.constraint(equalTo: self.bottomIndicatorImageView.centerYAnchor),
            self.bottomIndicatorLabel.trailingAnchor.constraint(equalTo: self.unfoldButton.leadingAnchor, constant: bottomIndicatorLabelRightMargin),
            self.bottomIndicatorLabel.leadingAnchor.constraint(equalTo: self.bottomIndicatorImageView.trailingAnchor, constant: bottomIndicatorLabelLeftMargin)
        ])
        
        self.addSubview(self.headerView)
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.bottomIndicatorView.bottomAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])
        
        self.headerView.addSubview(self.headerBottomBorderView)
        self.headerBottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerBottomBorderView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.headerBottomBorderView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
            self.headerBottomBorderView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
            self.headerBottomBorderView.heightAnchor.constraint(equalToConstant: headerBottomBorderHeight)
        ])
        
        self.headerView.addSubview(self.busNumberLabel)
        self.busNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busNumberLabel.topAnchor.constraint(equalTo: self.headerView.topAnchor, constant: busNumberLabelTopMargin),
            self.busNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: busNumberLabelRightMargin),
            self.busNumberLabel.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: busNumberLabelLeftMargin)
        ])
        
        self.headerView.addSubview(self.foldButton)
        self.foldButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.foldButton.centerYAnchor.constraint(equalTo: self.busNumberLabel.centerYAnchor),
            self.foldButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: foldUnfoldButtonRightMargin),
            self.foldButton.heightAnchor.constraint(equalToConstant: foldUnfoldButtonHeight),
            self.foldButton.widthAnchor.constraint(equalToConstant: foldUnfoldButtonWidth)
        ])
        
        self.headerView.addSubview(self.alarmStatusLabel)
        self.alarmStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmStatusLabel.topAnchor.constraint(equalTo: self.busNumberLabel.bottomAnchor, constant: alarmStatusLabelTopMargin),
            self.alarmStatusLabel.leadingAnchor.constraint(equalTo: self.busNumberLabel.leadingAnchor),
            self.alarmStatusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: alarmStatusLabelRightMargin)
        ])
        
        self.addSubview(self.endAlarmView)
        self.endAlarmView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.endAlarmView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.endAlarmView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.endAlarmView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.endAlarmView.heightAnchor.constraint(equalToConstant: bottomIndicatorAndEndAlarmViewHeight)
        ])
        
        self.endAlarmView.addSubview(self.endAlarmLabel)
        self.endAlarmLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.endAlarmLabel.topAnchor.constraint(equalTo: self.endAlarmView.topAnchor, constant: endAlarmLabelTopMargin),
            self.endAlarmLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        self.addSubview(self.stationsTableView)
        self.stationsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationsTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.stationsTableView.bottomAnchor.constraint(equalTo: self.endAlarmView.topAnchor),
            self.stationsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stationsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    func configureDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource) {
        self.stationsTableView.delegate = delegate
        self.stationsTableView.dataSource = delegate
    }
    
    func addBusTag() {
        let busTagLeftMargin: CGFloat = 5
        
        let busTag = MovingStatusBusTagView()
        
        self.stationsTableView.addSubview(busTag)
        busTag.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busTag.leadingAnchor.constraint(equalTo: self.stationsTableView.leadingAnchor, constant: busTagLeftMargin),
            busTag.centerYAnchor.constraint(equalTo: self.stationsTableView.topAnchor, constant: (MovingStatusTableViewCell.cellHeight/2) + 2*MovingStatusTableViewCell.cellHeight)
        ])
    }
}
