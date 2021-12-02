//
//  AlarmSettingUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class AlarmSettingAPIUseCase: AlarmSettingAPIUsable {
    typealias AlarmSettingUseCases = GetArrInfoByRouteListUsable & GetStationsByRouteListUsable
    
    private let useCases: AlarmSettingUseCases
    @Published private(set) var networkError: Error?
    
    init(useCases: AlarmSettingUseCases) {
        self.useCases = useCases
        self.networkError = nil
    }
    
    func busArriveInfoWillLoaded(stId: String, busRouteId: String, ord: String) -> AnyPublisher<ArrInfoByRouteDTO, Error> {
        return self.useCases.getArrInfoByRouteList(stId: stId,
                                            busRouteId: busRouteId,
                                            ord: ord)
            .decode(type: ArrInfoByRouteResult.self, decoder: JSONDecoder())
            .tryMap({ item -> ArrInfoByRouteDTO in
                let result = item.msgBody.itemList
                guard let item = result.first else { throw BBusAPIError.wrongFormatError }
                return item
            })
            .eraseToAnyPublisher()
    }
    
    func busStationsInfoWillLoaded(busRouetId: String, arsId: String) -> AnyPublisher<[StationByRouteListDTO]?, Error> {
        return self.useCases.getStationsByRouteList(busRoutedId: busRouetId)
            .decode(type: StationByRouteResult.self, decoder: JSONDecoder())
            .map({ item -> [StationByRouteListDTO]? in
                let result = item.msgBody.itemList
                guard let index = result.firstIndex(where: { $0.arsId == arsId }) else { return nil }
                return Array(result[index..<result.count])
            })
            .eraseToAnyPublisher()
    }
    
}
