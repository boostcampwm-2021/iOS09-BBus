//
//  MovingStatusCoordinator.swift
//  BBus
//
//  Created by 최수정 on 2021/11/09.
//

import Foundation

protocol MovingStatusOpenCloseDelegate: AnyObject {
    func open()
    func close()
}

protocol MovingStatusFoldUnfoldDelegate {
    func fold()
    func unfold()
}
