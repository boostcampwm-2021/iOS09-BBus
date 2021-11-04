//
//  SearchBusViewController.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import UIKit

class SearchBusViewController: UIViewController {

    private lazy var searchTextField: UITextField = {
        let textField = UITextField(frame: CGRect(origin: CGPoint(), size: CGSize(width: self.view.frame.width - (self.navigationItem.leftBarButtonItem?.width ?? 0), height: 30)))
        textField.placeholder = "버스 입력"
        textField.backgroundColor = UIColor.gray
        return textField
    }()
    weak var coordinator: SearchBusCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SearchBus"
        self.view.backgroundColor = UIColor.green
        self.navigationItem.titleView = self.searchTextField
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.coordinator?.terminate()
        }
    }
}
