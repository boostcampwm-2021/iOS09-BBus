//
//  BaseViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/29.
//

import Foundation

protocol BaseViewController: AnyObject {
    // MARK: configure
    func configureLayout()
    func configureDelegate()

    // MARK: bind
    func bindAll()
}
