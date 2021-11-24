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

final class MovingStatusView: UIView {
    
    static let bottomIndicatorHeight: CGFloat = 80
    static let endAlarmViewHeight: CGFloat = 80
    
    private weak var bottomIndicatorButtondelegate: BottomIndicatorButtonDelegate? {
        didSet {
            self.bottomIndicatorButton.addAction(UIAction(handler: { [weak self] _ in
                self?.bottomIndicatorButtondelegate?.shouldUnfoldMovingStatusView()
            }), for: .touchUpInside)
        }
    }
    private weak var foldButtonDelegate: FoldButtonDelegate? {
        didSet {
            self.foldButton.addAction(UIAction(handler: { [weak self] _ in
                self?.foldButtonDelegate?.shouldFoldMovingStatusView()
            }), for: .touchUpInside)
        }
    }
    private weak var endAlarmButtonDelegate: EndAlarmButtonDelegate? {
        didSet {
            self.endAlarmButton.addAction(UIAction(handler: { [weak self] _ in
                self?.endAlarmButtonDelegate?.shouldEndAlarm()
            }), for: .touchUpInside)
        }
    }
    
    private lazy var bottomIndicatorButton: UIButton = {
        let button = UIButton()
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
        return label
    }()
    private lazy var unfoldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = BBusColor.white
        imageView.image = BBusImage.unfold
        return imageView
    }()
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = BBusColor.white
        return view
    }()
    private lazy var headerBottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = BBusColor.bbusLightGray
        return view
    }()
    private lazy var busNumberLabel: UILabel = {
        let labelFontSize: CGFloat = 27
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        return label
    }()
    private lazy var alarmStatusLabel: UILabel = {
        let labelFontSize: CGFloat = 14
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: labelFontSize)
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
        self.configureColor(to: BBusColor.gray)
        self.configureBusName(to: "탐색중")
        self.configureHeaderInfo(remainStation: nil, remainTime: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureLayout()
        self.configureColor(to: BBusColor.gray)
        self.configureBusName(to: "탐색중")
        self.configureHeaderInfo(remainStation: nil, remainTime: nil)
    }

    // MARK: - Configure
    private func configureLayout() {
        self.addSubviews(self.bottomIndicatorButton, self.endAlarmButton, self.stationsTableView, self.headerView)
        
        NSLayoutConstraint.activate([
            self.bottomIndicatorButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.bottomIndicatorButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomIndicatorButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bottomIndicatorButton.heightAnchor.constraint(equalToConstant: Self.bottomIndicatorHeight)
        ])
        
        let bottomIndicatorImageViewSize: CGFloat = 25
        let bottomIndicatorImgaeViewTopMargin: CGFloat = 13
        let bottomIndicatorImageViewLeftMargin: CGFloat = 25
        self.bottomIndicatorButton.addSubviews(self.bottomIndicatorImageView, self.unfoldImageView, self.bottomIndicatorLabel)
        NSLayoutConstraint.activate([
            self.bottomIndicatorImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: bottomIndicatorImgaeViewTopMargin),
            self.bottomIndicatorImageView.heightAnchor.constraint(equalToConstant: bottomIndicatorImageViewSize),
            self.bottomIndicatorImageView.widthAnchor.constraint(equalTo: self.bottomIndicatorImageView.heightAnchor),
            self.bottomIndicatorImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: bottomIndicatorImageViewLeftMargin)
        ])
        
        let unfoldButtonRightMargin: CGFloat = -20
        let unfoldButtonWidth: CGFloat = 20
        let unfoldButtonHeight: CGFloat = 20
        NSLayoutConstraint.activate([
            self.unfoldImageView.centerYAnchor.constraint(equalTo: self.bottomIndicatorImageView.centerYAnchor),
            self.unfoldImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: unfoldButtonRightMargin),
            self.unfoldImageView.heightAnchor.constraint(equalToConstant: unfoldButtonHeight),
            self.unfoldImageView.widthAnchor.constraint(equalToConstant: unfoldButtonWidth)
        ])
        
        let bottomIndicatorLabelRightMargin: CGFloat = -20
        let bottomIndicatorLabelLeftMargin: CGFloat = 10
        NSLayoutConstraint.activate([
            self.bottomIndicatorLabel.centerYAnchor.constraint(equalTo: self.bottomIndicatorImageView.centerYAnchor),
            self.bottomIndicatorLabel.trailingAnchor.constraint(equalTo: self.unfoldImageView.leadingAnchor, constant: bottomIndicatorLabelRightMargin),
            self.bottomIndicatorLabel.leadingAnchor.constraint(equalTo: self.bottomIndicatorImageView.trailingAnchor, constant: bottomIndicatorLabelLeftMargin)
        ])
        
        let headerHeight: CGFloat = 120
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.bottomIndicatorButton.bottomAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])
        
        self.headerView.addSubviews(self.headerBottomBorderView, self.busNumberLabel, self.foldButton, self.alarmStatusLabel)
        
        let headerBottomBorderHeight: CGFloat = 0.5
        NSLayoutConstraint.activate([
            self.headerBottomBorderView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.headerBottomBorderView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
            self.headerBottomBorderView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
            self.headerBottomBorderView.heightAnchor.constraint(equalToConstant: headerBottomBorderHeight)
        ])
        
        let busNumberLabelTopMargin: CGFloat = 45
        let busNumberLabelLeftMargin: CGFloat = 40
        let busNumberLabelRightMargin: CGFloat = -70
        NSLayoutConstraint.activate([
            self.busNumberLabel.topAnchor.constraint(equalTo: self.headerView.topAnchor, constant: busNumberLabelTopMargin),
            self.busNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: busNumberLabelRightMargin),
            self.busNumberLabel.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: busNumberLabelLeftMargin)
        ])
        
        let foldImageViewMargin: CGFloat = 10
        let foldButtonRightMargin: CGFloat = unfoldButtonRightMargin + foldImageViewMargin
        NSLayoutConstraint.activate([
            self.foldButton.centerYAnchor.constraint(equalTo: self.busNumberLabel.centerYAnchor),
            self.foldButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: foldButtonRightMargin)
        ])
        
        self.foldButton.addSubviews(self.foldImageView)
        
        let foldButtonHeight = unfoldButtonHeight
        let foldButtonWidth = unfoldButtonWidth
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
        NSLayoutConstraint.activate([
            self.alarmStatusLabel.topAnchor.constraint(equalTo: self.busNumberLabel.bottomAnchor, constant: alarmStatusLabelTopMargin),
            self.alarmStatusLabel.leadingAnchor.constraint(equalTo: self.busNumberLabel.leadingAnchor),
            self.alarmStatusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: alarmStatusLabelRightMargin)
        ])
        
        NSLayoutConstraint.activate([
            self.endAlarmButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.endAlarmButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.endAlarmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.endAlarmButton.heightAnchor.constraint(equalToConstant: Self.endAlarmViewHeight)
        ])
        
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
    
    func createBusTag(location: CGFloat = 0, color: UIColor? = BBusColor.gray, busIcon: UIImage? = BBusImage.blueBusIcon, remainStation: Int?) -> MovingStatusBusTagView {
        let busTagLeftMargin: CGFloat = 5
        
        let busTag = MovingStatusBusTagView()
        busTag.configureInfo(color: color,
                         busIcon: busIcon,
                         remainStation: remainStation)
        
        self.stationsTableView.addSubviews(busTag)
        
        NSLayoutConstraint.activate([
            busTag.leadingAnchor.constraint(equalTo: self.stationsTableView.leadingAnchor, constant: busTagLeftMargin),
            busTag.centerYAnchor.constraint(equalTo: self.stationsTableView.topAnchor, constant: (MovingStatusTableViewCell.cellHeight/2) + location*MovingStatusTableViewCell.cellHeight)
        ])

        return busTag
    }

    func configureColor(to color: UIColor?) {
        self.bottomIndicatorButton.backgroundColor = color
        self.busNumberLabel.textColor = color
        self.endAlarmButton.backgroundColor = color
    }

    func configureBusName(to: String) {
        self.busNumberLabel.text = to
    }

    func configureHeaderInfo(remainStation: Int? = nil, remainTime: Int?) {
        var headerInfoResult: String = ""
        let currentInfo: String

        if let remainStation = remainStation {
            currentInfo = remainStation > 1 ? "\(remainStation)정거장 남음" : "이번에 내리세요!"
        } else {
            currentInfo = "현위치 탐색중"
        }
        if let remainTime = remainTime,
           let remainStation = remainStation {
            headerInfoResult = remainStation > 1 ? "\(currentInfo), \(remainTime)분 소요예정" : currentInfo
        } else {
            headerInfoResult = currentInfo
        }

        self.bottomIndicatorLabel.text = headerInfoResult
        self.alarmStatusLabel.text = headerInfoResult
    }

    func reload() {
        self.stationsTableView.reloadData()
    }
}
