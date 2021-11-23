//
//  AlarmSettingUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class AlarmSettingUseCase {
    static let queue = DispatchQueue.init(label: "alarmSetting")
    
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
        Self.queue.async {
            self.useCases.getArrInfoByRouteList(stId: stId,
                                                busRouteId: busRouteId,
                                                ord: ord)
                .receive(on: Self.queue)
                .tryMap ({ info -> ArrInfoByRouteDTO in
                    guard let result = BBusXMLParser().parse(dtoType: ArrInfoByRouteResult.self, xml: info),
                          let item = result.body.itemList.first else { throw BBusAPIError.wrongFormatError }
                    return item
                })
                .retry ({ [weak self] in
                    self?.busArriveInfoWillLoaded(stId: stId, busRouteId: busRouteId, ord: ord)
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .sink(receiveValue: { [weak self] busArriveInfo in
                    self?.busArriveInfo = busArriveInfo
                })
                .store(in: &self.cancellables)
        }
    }
    
    func busStationsInfoWillLoaded(busRouetId: String, arsId: String) {
        Self.queue.async {
            self.useCases.getStationsByRouteList(busRoutedId: busRouetId)
                .receive(on: Self.queue)
                .tryMap({ data in
                    guard let result = BBusXMLParser().parse(dtoType: StationByRouteResult.self, xml: data)?.body.itemList,
                          let index = result.firstIndex(where: { $0.arsId == arsId }) else { return nil }
                    return Array(result[index..<result.count])
                })
                // 에러를 throw하지 않고 nil을 반환하게 하여 retry가 필요하지 않음.
                .retry({ [weak self] in
                    self?.busStationsInfoWillLoaded(busRouetId: busRouetId, arsId: arsId)
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .sink(receiveValue: { [weak self] busStationsInfo in
                    self?.busStationsInfo = busStationsInfo
                })
                .store(in: &self.cancellables)
        }
    }
    
}
