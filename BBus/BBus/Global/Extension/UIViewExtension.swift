//
//  UIViewExtension.swift
//  BBus
//
//  Created by 이지수 on 2021/11/16.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views : UIView...) {
        views.forEach() { view in
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
