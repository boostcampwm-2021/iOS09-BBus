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
    @Published private(set) var busStationsInfo: [StationByRouteListDTO]
    private var cancellables: Set<AnyCancellable>
    
    init(useCases: AlarmSettingUseCases) {
        self.useCases = useCases
        self.busArriveInfo = nil
        self.busStationsInfo = []
        self.cancellables = []
    }
    
    func busArriveInfoWillLoaded(stId: String, busRouteId: String, ord: String) {
        Self.queue.async {
            self.useCases.getArrInfoByRouteList(stId: stId,
                                                busRouteId: busRouteId,
                                                ord: ord)
                .receive(on: Self.queue)
                .sink(receiveCompletion: { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                }, receiveValue: { data in
                    guard let result = BBusXMLParser().parse(dtoType: ArrInfoByRouteResult.self, xml: data),
                          let item = result.body.itemList.first else { return }
                    self.busArriveInfo = item
                })
                .store(in: &self.cancellables)
        }
    }
    
    func busStationsInfoWillLoaded(busRouetId: String, arsId: String) {
        Self.queue.async {
            self.useCases.getStationsByRouteList(busRoutedId: busRouetId)
                .receive(on: Self.queue)
                .sink(receiveCompletion: { error in
                    if case .failure(let error) = error {
                        print(error)
                    }
                }, receiveValue: { [weak self] data in
                    guard let result = BBusXMLParser().parse(dtoType: StationByRouteResult.self, xml: data)?.body.itemList,
                          let index = result.firstIndex(where: { $0.arsId == arsId }) else { return }
                    self?.busStationsInfo = Array(result[index..<result.count])
                    
                })
                .store(in: &self.cancellables)
        }
    }
    
}
