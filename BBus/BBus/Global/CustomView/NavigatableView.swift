//
//  NavigatableView.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/30.
//

import UIKit

class NavigatableView: RefreshableView {

    internal lazy var navigationBar = CustomNavigationBar()

    override func configureLayout() {
        self.addSubviews(self.navigationBar)

        NSLayoutConstraint.activate([
            self.navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        super.configureLayout()
    }
}
