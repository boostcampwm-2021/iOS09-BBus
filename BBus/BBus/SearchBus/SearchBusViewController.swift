//
//  SearchBusViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class SearchBusViewController: UIViewController {

    weak var coordinator: SearchBusCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SearchBus"
        self.view.backgroundColor = .red
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.coordinator?.terminate()
        }
    }
}
