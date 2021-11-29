//
//  AlarmSettingUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class AlarmSettingUseCase {
    typealias AlarmSettingUseCases = GetArrInfoByRouteListUsecase & GetStationsByRouteListUsecase
    
    private let useCases: AlarmSettingUseCases
    @Published private(set) var busArriveInfo: ArrInfoByRouteDTO?
    @Published private(set) var busStationsInfo: [StationByRouteListDTO]?
    @Published private(set) var networkError: Error?
    private var cancellables: Set<AnyCancellable>
    
    init(useCases: AlarmSettingUseCases) {
        self.useCases = useCases
        self.busArriveInfo = nil
        self.busStationsInfo = []
        self.networkError = nil
        self.cancellables = []
    }
    
    func busArriveInfoWillLoaded(stId: String, busRouteId: String, ord: String) {
        self.useCases.getArrInfoByRouteList(stId: stId,
                                            busRouteId: busRouteId,
                                            ord: ord)
            .decode(type: ArrInfoByRouteResult.self, decoder: JSONDecoder())
            .tryMap({ item in
                let result = item.msgBody.itemList
                guard let item = result.first else { throw BBusAPIError.wrongFormatError }
                return item
            })
            .retry ({ [weak self] in
                self?.busArriveInfoWillLoaded(stId: stId, busRouteId: busRouteId, ord: ord)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$busArriveInfo)
    }
    
    func busStationsInfoWillLoaded(busRouetId: String, arsId: String) {
        self.useCases.getStationsByRouteList(busRoutedId: busRouetId)
            .decode(type: StationByRouteResult.self, decoder: JSONDecoder())
            .retry({ [weak self] in
                self?.busStationsInfoWillLoaded(busRouetId: busRouetId, arsId: arsId)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .map({ item in
                let result = item.msgBody.itemList
                guard let index = result.firstIndex(where: { $0.arsId == arsId }) else { return nil }
                return Array(result[index..<result.count])
            })
            .assign(to: &self.$busStationsInfo)
    }
    
}
