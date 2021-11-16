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
    
    typealias AlarmSettingUseCases = GetArrInfoByRouteListUsecase
    
    private let useCases: AlarmSettingUseCases
    @Published private(set) var busArriveInfo: ArrInfoByRouteDTO?
    private var cancellables: Set<AnyCancellable>
    
    init(useCases: AlarmSettingUseCases) {
        self.useCases = useCases
        self.busArriveInfo = nil
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
    
    
}
