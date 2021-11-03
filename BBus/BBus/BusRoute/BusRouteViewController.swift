//
//  BusRouteViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class BusRouteViewController: UIViewController {

    weak var coordinator: BusRouteCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.systemBackground
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.coordinator?.terminate()
        }
    }

}
