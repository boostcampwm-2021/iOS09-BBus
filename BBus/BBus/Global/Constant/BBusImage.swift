//
//  Image.swift
//  BBus
//
//  Created by 최수정 on 2021/11/09.
//

import UIKit

enum BBusImage {
    static let refresh: UIImage? = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        return UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: largeConfig)
    }()
    static let alarm: UIImage? = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        return UIImage(systemName: "alarm", withConfiguration: largeConfig)
    }()
    static let back: UIImage? = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        return UIImage(systemName: "chevron.left", withConfiguration: largeConfig)
    }()
    static let bus = UIImage(systemName: "bus.fill")
    static let station = UIImage(systemName: "bitcoinsign.circle")
    static let keyboardDown = UIImage(systemName: "keyboard.chevron.compact.down")
    static let filledStar: UIImage? = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        return UIImage(systemName: "star.fill", withConfiguration: largeConfig)
    }()
}
