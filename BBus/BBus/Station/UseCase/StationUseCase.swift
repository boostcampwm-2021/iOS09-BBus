//
//  StationUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class StationUsecase {
    static let queue = DispatchQueue.init(label: "station")
    
    private let usecases: GetStationByUidItemUsecase & GetStationListUsecase
    @Published private(set) var busArriveInfo: [StationByUidItemDTO]
    @Published private(set) var stationInfo: StationDTO?
    private var cancellables: Set<AnyCancellable>
    
    init(usecases: GetStationByUidItemUsecase & GetStationListUsecase) {
        self.usecases = usecases
        self.busArriveInfo = []
        self.stationInfo = nil
        self.cancellables = []
    }
    
    func stationInfoWillLoad(with arsId: String) {
        self.usecases.getStationList()
            .receive(on: Self.queue)
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { stations in
                self.stationInfo = self.findStation(in: stations, with: arsId)
            })
            .store(in: &self.cancellables)
    }
    
    private func findStation(in stations: [StationDTO], with arsId: String) -> StationDTO? {
        let station = stations.filter() { $0.arsID == arsId }
        return station.first
    }
    
    func refreshInfo(about arsId: String) {
        self.usecases.getStationByUidItem(arsId: arsId)
            .receive(on: Self.queue)
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { data in
                guard let result = BBusXMLParser().parse(dtoType: StationByUidItemResult.self, xml: data) else { return }
                let realTimeInfo = result.body.itemList
                self.busArriveInfo = realTimeInfo
            })
            .store(in: &self.cancellables)
    }
}
