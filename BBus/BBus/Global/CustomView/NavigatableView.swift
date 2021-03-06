//
//  NavigatableView.swift
//  BBus
//
//  Created by κΉνν on 2021/11/30.
//

import UIKit

class NavigatableView: RefreshableView {

    lazy var navigationBar = CustomNavigationBar()

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
