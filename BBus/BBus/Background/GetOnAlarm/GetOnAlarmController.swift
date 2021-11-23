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

    @Published private(set) var viewModel: GetOnAlarmViewModel?
    
    private override init() { }

    func start(targetOrd: Int, vehicleId: Int, busName: String, busRouteId: Int, stationId: Int) -> GetOnStartResult {
        if self.viewModel != nil {
            if isSameAlarm(targetOrd: targetOrd, vehicleId: vehicleId) {
                return .sameAlarm
            }
            else {
                return .duplicated
            }
        }
        else {
            let usecase = GetOnAlarmUsecase(usecases: BBusAPIUsecases(on: GetOnAlarmUsecase.queue))
            let getOnAlarmStatus = GetOnAlarmStatus(currentBusOrd: nil,
                                                    targetOrd: targetOrd,
                                                    vehicleId: vehicleId,
                                                    busName: busName,
                                                    busRouteId: busRouteId,
                                                    stationId: stationId)
            self.viewModel = GetOnAlarmViewModel(usecase: usecase, currentStatus: getOnAlarmStatus)
            self.viewModel?.fetch()
            self.bindingMessage()
            self.sendRequestAuthorization()
            self.configureLocationManager()
            return .success
        }
    }

    func stop() {
        self.viewModel = nil
        self.cancellable = nil
        self.locationManager = nil
    }
    
    private func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.startUpdatingLocation()
    }
    
    func bindingMessage() {
        self.cancellable = self.viewModel?.$getApproachStatus
            .sink(receiveValue: { [weak self] status in
                guard let status = status,
                      let message = self?.viewModel?.message else { return }
                if status == .oneStationLeft {
                    self?.stop()
                }
                self?.pushGetOnAlarm(message: message)
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

    private func isSameAlarm(targetOrd: Int, vehicleId: Int) -> Bool {
        guard let currentTargetOrd = self.viewModel?.getOnAlarmStatus.targetOrd,
              let currentVehicleId = self.viewModel?.getOnAlarmStatus.vehicleId else { return false }

        return currentTargetOrd == targetOrd && currentVehicleId == vehicleId
    }
}
