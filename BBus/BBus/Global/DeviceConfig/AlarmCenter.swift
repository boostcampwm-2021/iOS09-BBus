//
//  PermissionManager.swift
//  BBus
//
//  Created by 이지수 on 2021/11/30.
//

import CoreLocation
import UserNotifications
import UIKit

protocol AlarmManagable {
    func configurePermission()
    func pushAlarm(in identifier: String, title: String, message: String)
}

protocol AlarmDetailConfiguable: AlarmManagable {
    func configureLocationDetail(_: CLLocationManagerDelegate)
}

final class AlarmCenter: AlarmDetailConfiguable {
    private lazy var locationManager: CLLocationManager = CLLocationManager()
    private lazy var userNotificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    init() {}
    
    func configurePermission() {
        self.configureLocationManager()
        self.configureUserNotificationCenter()
    }
    
    func configureLocationDetail(_ delegate: CLLocationManagerDelegate) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = delegate
    }
    
    private func configureLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startUpdatingLocation()
    }
    
    private func configureUserNotificationCenter() {
        self.userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
            if !didAllow,
                let settingUrl = URL(string: UIApplication.openSettingsURLString) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(settingUrl)
                }
            }
        })
    }
    
    func pushAlarm(in identifier: String, title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.badge = Int(truncating: content.badge ?? 0) + 1 as NSNumber
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        self.userNotificationCenter.add(request, withCompletionHandler: nil)
    }
}
