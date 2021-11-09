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
    static let navigationBack = UIImage(systemName: "chevron.left")
    static let headerArrow = UIImage(systemName: "arrow.left.and.right")
    static let stationCenterCircle = UIImage(named: "StationCenterCircle")
    static let stationCenterGetOn = UIImage(named: "GetOn")
    static let stationCenterGetOff = UIImage(named: "GetOff")
    static let stationCenterUturn = UIImage(named: "Uturn")
    static let tagMaxSize = UIImage(named: "BusTagMaxSize")
    static let tagMinSize = UIImage(named: "BusTagMinSize")
    static let bbusBlueIcon = UIImage(named: "busIcon")

    static let waypoint = UIImage(named: "StationCenterCircle")
    static let getOn = UIImage(named: "GetOn")
    static let clockIcon = UIImage(systemName: "clock")
    static let locationIcon = UIImage(named: "locationIcon")
    static let busIcon = UIImage(named: "grayBusIcon")
    static let alarmOffIcon = UIImage(named: "alarmOff")
    static let alarmOnIcon = UIImage(named: "alarmOn")
}
