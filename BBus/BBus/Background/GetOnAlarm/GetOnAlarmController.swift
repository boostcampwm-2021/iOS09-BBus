//
//  GetOnAlarmDelegate.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation
import UIKit
import Combine
import CoreLocation

final class GetOnAlarmController: NSObject {
    
    static private let alarmIdentifier: String = "GetOnAlarm"

    static let shared = GetOnAlarmController()
    
    private var cancellable: AnyCancellable?
    private var locationManager: CLLocationManager?

    var status: (vehicleId: Int, targetOrd: Int)? {
        get {
            guard let viewModel = self.viewModel else { return nil }
            return (viewModel.getOnAlarmStatus.vehicleId, viewModel.getOnAlarmStatus.targetOrd)
        }
    }

    private(set) var viewModel: GetOnAlarmViewModel?
    
    private override init() { }

    func start(targetOrd: Int, vehicleId: Int, busName: String) {
        let usecase = GetOnAlarmUsecase(usecases: BBusAPIUsecases(on: GetOnAlarmUsecase.queue))
        let getOnAlarmStatus = GetOnAlarmStatus(currentBusOrd: nil,
                                                targetOrd: targetOrd,
                                                vehicleId: vehicleId,
                                                busName: busName)
        self.viewModel = GetOnAlarmViewModel(usecase: usecase, currentStatus: getOnAlarmStatus)
        self.bindingMessage()
        self.viewModel?.fetch()
        self.sendRequestAuthorization()
        self.configureLocationManager()
    }

    func stop() {
        self.viewModel = nil
    }
    
    private func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.startUpdatingLocation()
    }
    
    func bindingMessage() {
        self.cancellable = self.viewModel?.$getApproachStatus
            .sink(receiveValue: { status in
                guard let status = status,
                      let message = self.viewModel?.message else { return }
                if status == .oneStationLeft {
                    self.viewModel = nil
                }
                self.pushGetOnAlarm(message: message)
            })
    }
    
    private func sendRequestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
            if let error = error {
                print(error)
            }
        })
    }
    
    private func pushGetOnAlarm(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "승차 알람"
        content.body = message
        content.badge = Int(truncating: content.badge ?? 0) + 1 as NSNumber
        let request = UNNotificationRequest(identifier: Self.alarmIdentifier, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
