//
//  RefreshButton.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/29.
//

import UIKit

final class RefreshButton: ThrottleButton {

    static let refreshButtonWidth: CGFloat = 50

    convenience init() {
        self.init(frame: CGRect())
        self.configureUI()
    }

    private func configureUI() {
        self.setImage(BBusImage.refresh, for: .normal)
        self.layer.cornerRadius = Self.refreshButtonWidth / 2
        self.tintColor = BBusColor.white
        self.backgroundColor = BBusColor.darkGray
    }

}
