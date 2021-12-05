//
//  GetOnAlarmUsecase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/22.
//

import Foundation
import Combine

protocol GetOnAlarmAPIUsable: BaseUseCase {
    func fetch(withVehId vehId: String)
}

final class GetOnAlarmAPIUseCase: GetOnAlarmAPIUsable {

    private let useCases: GetBusPosByVehIdUsable
    @Published private(set) var networkError: Error?
    @Published private(set) var busPosition: BusPosByVehicleIdDTO?

    init(useCases: GetBusPosByVehIdUsable) {
        self.useCases = useCases
        self.networkError = nil
        self.busPosition = nil
    }

    func fetch(withVehId vehId: String) {
        self.useCases.getBusPosByVehId(vehId)
            .decode(type: JsonMessage.self, decoder: JSONDecoder())
            .catchError({ error in
                self.networkError = error
            })
            .map({ item in
                item.msgBody.itemList.first
            })
            .assign(to: &self.$busPosition)
    }
}
