//
//  AlarmSettingViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class AlarmSettingViewController: UIViewController {

    weak var coordinator: AlarmSettingCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.coordinator?.terminate()
        }
    }

}
