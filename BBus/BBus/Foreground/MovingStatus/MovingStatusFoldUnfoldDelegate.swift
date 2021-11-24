//
//  MovingStatusCoordinator.swift
//  BBus
//
//  Created by 최수정 on 2021/11/09.
//

import Foundation

protocol MovingStatusOpenCloseDelegate: AnyObject {
    func open(busRouteId: Int, fromArsId: String, toArsId: String)
    func reset(busRouteId: Int, fromArsId: String, toArsId: String)
    func close()
}

protocol MovingStatusFoldUnfoldDelegate {
    func fold()
    func unfold()
}
