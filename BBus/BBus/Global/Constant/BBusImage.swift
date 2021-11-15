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
    static let keyboardDown = UIImage(systemName: "keyboard.chevron.compact.down")
    static let star: UIImage? = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        return UIImage(systemName: "star.fill", withConfiguration: largeConfig)
    }()
    static let booDuck = UIImage(named: "booDuck")
    static let unfold = UIImage(systemName: "chevron.up")
    static let fold = UIImage(systemName: "chevron.down")
    static let getOn = UIImage(named: "getOn")
    static let getOff = UIImage(named: "getOff")
    static let waypoint = UIImage(named: "stationCenterCircle")
    static let booduckBus = UIImage(named: "busIconWithBooDuck")
    static let speechBubble = UIImage(named: "speechBubble")
    static let navigationBack = UIImage(systemName: "chevron.left")
    static let headerArrow = UIImage(systemName: "arrow.left.and.right")
    static let stationCenterCircle = UIImage(named: "stationCenterCircle")
    static let stationCenterGetOn = UIImage(named: "getOn")
    static let stationCenterGetOff = UIImage(named: "getOff")
    static let stationCenterUturn = UIImage(named: "uturn")
    static let tagMaxSize = UIImage(named: "busTagMaxSize")
    static let tagMinSize = UIImage(named: "busTagMinSize")
    static let clockSymbol = UIImage(systemName: "clock")
    static let locationSymbol = UIImage(named: "locationSymbol")
    static let busGraySymbol = UIImage(named: "busGraySymbol")
    static let busRedSymbol = UIImage(systemName: "bus.fill")
    static let stationRedSymbol = UIImage(systemName: "bitcoinsign.circle")
    static let blueBusIcon = UIImage(named: "blueBusIcon")
    static let greenBusIcon = UIImage(named: "greenBusIcon")
    static let redBusIcon = UIImage(named: "redBusIcon")
    static let circulationBusIcon = UIImage(named: "circulationBusIcon")
    static let alarmOffIcon = UIImage(named: "alarmOff")
    static let alarmOnIcon = UIImage(named: "alarmOn")
}
