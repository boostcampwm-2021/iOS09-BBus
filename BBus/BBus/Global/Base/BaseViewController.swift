//
//  BaseViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/29.
//

import UIKit

protocol BaseViewControllerType: UIViewController {

    func viewDidLoad()
    
    // MARK: configure
    func configureLayout()
    func configureDelegate()
    func refresh()

    // MARK: bind
    func bindAll()
}

extension BaseViewControllerType {
    func baseViewDidLoad() {
        self.configureLayout()
        self.configureDelegate()
        self.bindAll()
    }
    
    func baseViewWillAppear() {
        self.refresh()
    }
}
