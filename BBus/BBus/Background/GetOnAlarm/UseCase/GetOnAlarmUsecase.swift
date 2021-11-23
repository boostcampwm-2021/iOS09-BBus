//
//  GetOnAlarmUsecase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation
import Combine

class GetOnAlarmUsecase {

    private let usecases: GetBusPosByVehIdUsecase
    private var cancellable: AnyCancellable?
    static let queue = DispatchQueue.init(label: "GetOnAlarm")
    @Published private(set) var networkError: Error?
    @Published private(set) var busPosition: BusPosByVehicleIdDTO?

    init(usecases: GetBusPosByVehIdUsecase) {
        self.usecases = usecases
        self.cancellable = nil
        self.networkError = nil
        self.busPosition = nil
    }

    func fetch(withVehId vehId: String) {

        Self.queue.async {
            self.cancellable = self.usecases.getBusPosByVehId(vehId)
                .receive(on: Self.queue)
                .decode(type: Welcome.self, decoder: JSONDecoder())
                .retry({ [weak self] in
                    self?.fetch(withVehId: vehId)
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .map({ item in
                    item.msgBody.itemList.first
                })
                .assign(to: \.busPosition, on: self)

        }
    }
}