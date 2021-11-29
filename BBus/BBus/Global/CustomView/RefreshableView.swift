//
//  RefreshableView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/29.
//

import UIKit

protocol RefreshButtonDelegate {
    func buttonTapped()
}

class RefreshableView: UIView {

    internal lazy var refreshButton = RefreshButton()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    private func configureLayout() {
        self.addSubviews(self.refreshButton)

        let refreshTrailingBottomInterval: CGFloat = -16
        NSLayoutConstraint.activate([
            self.refreshButton.widthAnchor.constraint(equalToConstant: RefreshButton.refreshButtonWidth),
            self.refreshButton.heightAnchor.constraint(equalTo: self.refreshButton.widthAnchor),
            self.refreshButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: refreshTrailingBottomInterval),
            self.refreshButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: refreshTrailingBottomInterval)
        ])
    }
}
