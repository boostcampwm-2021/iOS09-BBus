//
//  MovingStatusView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

protocol BottomIndicatorButtonDelegate: AnyObject {
    func shouldUnfoldMovingStatusView()
}

protocol FoldButtonDelegate: AnyObject {
    func shouldFoldMovingStatusView()
}

protocol EndAlarmButtonDelegate: AnyObject {
    func shouldEndAlarm()
}

class MovingStatusView: UIView {
    
    static let bottomIndicatorHeight: CGFloat = 80
    
    private weak var bottomIndicatorButtondelegate: BottomIndicatorButtonDelegate? {
        didSet {
            self.bottomIndicatorButton.addAction(UIAction(handler: { _ in
                self.bottomIndicatorButtondelegate?.shouldUnfoldMovingStatusView()
            }), for: .touchUpInside)
        }
    }
    private weak var foldButtonDelegate: FoldButtonDelegate? {
        didSet {
            self.foldButton.addAction(UIAction(handler: { _ in
                self.foldButtonDelegate?.shouldFoldMovingStatusView()
            }), for: .touchUpInside)
        }
    }
    private weak var endAlarmButtonDelegate: EndAlarmButtonDelegate? {
        didSet {
            self.endAlarmButton.addAction(UIAction(handler: { _ in
                self.endAlarmButtonDelegate?.shouldEndAlarm()
            }), for: .touchUpInside)
        }
    }
    
    private lazy var bottomIndicatorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = BBusColor.bbusTypeBlue
        return button
    }()
    private lazy var bottomIndicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = BBusImage.booDuck
        return imageView
    }()
    private lazy var bottomIndicatorLabel: UILabel = {
        let labelFontSize: CGFloat = 15
        
        let label = UILabel()
        label.textColor = BBusColor.white
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .semibold)
        label.text = "현위치 탐색중, 19분 소요예정"
        return label
    }()
    private lazy var unfoldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = BBusColor.white
        imageView.image = BBusImage.unfold
        return imageView
    }()
    private lazy var headerView = UIView()
    private lazy var headerBottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = BBusColor.bbusLightGray
        return view
    }()
    private lazy var busNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 27
        
        let label = UILabel()
        label.textColor = BBusColor.bbusTypeBlue
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        label.text = "700"
        return label
    }()
    private lazy var alarmStatusLabel: UILabel = {
        let labelFontSize: CGFloat = 14
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        label.text = "현위치 탐색중, 19분 소요예정"
        label.textColor = BBusColor.black
        return label
    }()
    private lazy var foldButton = UIButton()
    private lazy var foldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = BBusColor.black
        imageView.image = BBusImage.fold
        return imageView
    }()
    private lazy var stationsTableView: UITableView = {
        let tableViewContentTopInset: CGFloat = 10
        let tableViewleftBottomRightInset: CGFloat = 0
        
        let tableView = UITableView()
        tableView.register(MovingStatusTableViewCell.self, forCellReuseIdentifier: MovingStatusTableViewCell.reusableID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = BBusColor.white
        tableView.contentInset = UIEdgeInsets(top: tableViewContentTopInset,
                                              left: tableViewleftBottomRightInset,
                                              bottom: tableViewleftBottomRightInset,
                                              right: tableViewleftBottomRightInset)
        return tableView
    }()
    private lazy var endAlarmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = BBusColor.bbusTypeBlue
        button.tintColor = BBusColor.white
        button.setTitle("알람 종료", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 10,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        return button
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.configureLayout()
        self.bottomIndicatorButton.backgroundColor = BBusColor.bbusTypeBlue
        self.headerView.backgroundColor = BBusColor.white
        self.endAlarmButton.backgroundColor = BBusColor.bbusTypeBlue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureLayout()
        self.bottomIndicatorButton.backgroundColor = BBusColor.bbusTypeBlue
        self.headerView.backgroundColor = BBusColor.white
        self.endAlarmButton.backgroundColor = BBusColor.bbusTypeBlue
    }

    // MARK: - Configure
    private func configureLayout() {
        self.addSubview(self.bottomIndicatorButton)
        self.bottomIndicatorButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomIndicatorButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.bottomIndicatorButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomIndicatorButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bottomIndicatorButton.heightAnchor.constraint(equalToConstant: Self.bottomIndicatorHeight)
        ])
        
        let bottomIndicatorImageViewSize: CGFloat = 25
        let bottomIndicatorImgaeViewTopMargin: CGFloat = 13
        let bottomIndicatorImageViewLeftMargin: CGFloat = 25
        
        self.bottomIndicatorButton.addSubview(self.bottomIndicatorImageView)
        self.bottomIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomIndicatorImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: bottomIndicatorImgaeViewTopMargin),
            self.bottomIndicatorImageView.heightAnchor.constraint(equalToConstant: bottomIndicatorImageViewSize),
            self.bottomIndicatorImageView.widthAnchor.constraint(equalTo: self.bottomIndicatorImageView.heightAnchor),
            self.bottomIndicatorImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: bottomIndicatorImageViewLeftMargin)
        ])
        
        let unfoldButtonRightMargin: CGFloat = -20
        let unfoldButtonWidth: CGFloat = 20
        let unfoldButtonHeight: CGFloat = 20
        
        self.bottomIndicatorButton.addSubview(self.unfoldImageView)
        self.unfoldImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.unfoldImageView.centerYAnchor.constraint(equalTo: self.bottomIndicatorImageView.centerYAnchor),
            self.unfoldImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: unfoldButtonRightMargin),
            self.unfoldImageView.heightAnchor.constraint(equalToConstant: unfoldButtonHeight),
            self.unfoldImageView.widthAnchor.constraint(equalToConstant: unfoldButtonWidth)
        ])
        
        let bottomIndicatorLabelRightMargin: CGFloat = -20
        let bottomIndicatorLabelLeftMargin: CGFloat = 10
        
        self.bottomIndicatorButton.addSubview(self.bottomIndicatorLabel)
        self.bottomIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomIndicatorLabel.centerYAnchor.constraint(equalTo: self.bottomIndicatorImageView.centerYAnchor),
            self.bottomIndicatorLabel.trailingAnchor.constraint(equalTo: self.unfoldImageView.leadingAnchor, constant: bottomIndicatorLabelRightMargin),
            self.bottomIndicatorLabel.leadingAnchor.constraint(equalTo: self.bottomIndicatorImageView.trailingAnchor, constant: bottomIndicatorLabelLeftMargin)
        ])
        
        let headerHeight: CGFloat = 120
        
        self.addSubview(self.headerView)
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.bottomIndicatorButton.bottomAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])
        
        let headerBottomBorderHeight: CGFloat = 0.5
        
        self.headerView.addSubview(self.headerBottomBorderView)
        self.headerBottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerBottomBorderView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.headerBottomBorderView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
            self.headerBottomBorderView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
            self.headerBottomBorderView.heightAnchor.constraint(equalToConstant: headerBottomBorderHeight)
        ])
        
        let busNumberLabelTopMargin: CGFloat = 45
        let busNumberLabelLeftMargin: CGFloat = 40
        let busNumberLabelRightMargin: CGFloat = -70
        
        self.headerView.addSubview(self.busNumberLabel)
        self.busNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.busNumberLabel.topAnchor.constraint(equalTo: self.headerView.topAnchor, constant: busNumberLabelTopMargin),
            self.busNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: busNumberLabelRightMargin),
            self.busNumberLabel.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: busNumberLabelLeftMargin)
        ])
        
        let foldImageViewMargin: CGFloat = 10
        let foldButtonRightMargin: CGFloat = unfoldButtonRightMargin + foldImageViewMargin
        
        self.headerView.addSubview(self.foldButton)
        self.foldButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.foldButton.centerYAnchor.constraint(equalTo: self.busNumberLabel.centerYAnchor),
            self.foldButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: foldButtonRightMargin)
        ])
        
        let foldButtonHeight = unfoldButtonHeight
        let foldButtonWidth = unfoldButtonWidth
        
        self.foldButton.addSubview(self.foldImageView)
        self.foldImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.foldImageView.topAnchor.constraint(equalTo: self.foldButton.topAnchor, constant: foldImageViewMargin),
            self.foldImageView.trailingAnchor.constraint(equalTo: self.foldButton.trailingAnchor, constant: -foldImageViewMargin),
            self.foldImageView.leadingAnchor.constraint(equalTo: self.foldButton.leadingAnchor, constant: foldImageViewMargin),
            self.foldImageView.bottomAnchor.constraint(equalTo: self.foldButton.bottomAnchor, constant: -foldImageViewMargin),
            self.foldImageView.heightAnchor.constraint(equalToConstant: foldButtonHeight),
            self.foldImageView.widthAnchor.constraint(equalToConstant: foldButtonWidth)
        ])
        
        let alarmStatusLabelTopMargin: CGFloat = 4
        let alarmStatusLabelRightMargin: CGFloat = -50
        
        self.headerView.addSubview(self.alarmStatusLabel)
        self.alarmStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.alarmStatusLabel.topAnchor.constraint(equalTo: self.busNumberLabel.bottomAnchor, constant: alarmStatusLabelTopMargin),
            self.alarmStatusLabel.leadingAnchor.constraint(equalTo: self.busNumberLabel.leadingAnchor),
            self.alarmStatusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: alarmStatusLabelRightMargin)
        ])
        
        let endAlarmViewHeight: CGFloat = 80
        
        self.addSubview(self.endAlarmButton)
        self.endAlarmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.endAlarmButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.endAlarmButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.endAlarmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.endAlarmButton.heightAnchor.constraint(equalToConstant: endAlarmViewHeight)
        ])
        
        self.addSubview(self.stationsTableView)
        self.stationsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stationsTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.stationsTableView.bottomAnchor.constraint(equalTo: self.endAlarmButton.topAnchor),
            self.stationsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stationsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    func configureDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource & BottomIndicatorButtonDelegate & FoldButtonDelegate & EndAlarmButtonDelegate) {
        self.stationsTableView.delegate = delegate
        self.stationsTableView.dataSource = delegate
        self.bottomIndicatorButtondelegate = delegate
        self.foldButtonDelegate = delegate
        self.endAlarmButtonDelegate = delegate
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
