//
//  StationUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class StationUsecase {
    static let thread = DispatchQueue.init(label: "station")
    
    private let usecases: GetStationByUidItemUsecase & GetStationListUsecase
    @Published private(set) var busArriveInfo: [StationByUidItemDTO]
    @Published private(set) var stationInfo: StationDTO?
    private var cancellable: Set<AnyCancellable>
    
    init(usecases: GetStationByUidItemUsecase & GetStationListUsecase) {
        self.usecases = usecases
        self.busArriveInfo = []
        self.stationInfo = nil
        self.cancellable = []
    }
    
    func stationInfoWillLoad(with arsId: String) {
        self.usecases.getStationList()
            .receive(on: Self.thread)
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { stations in
                self.stationInfo = self.findStation(in: stations, with: arsId)
            })
            .store(in: &self.cancellable)
    }
    
    func refreshInfo(about arsId: String) {
        self.usecases.getStationByUidItem(arsId: arsId)
            .receive(on: Self.thread)
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { data in
                guard let result = BBusXMLParser().parse(dtoType: StationByUidItemResult.self, xml: data) else { return }
                let realTimeInfo = result.body.itemList
                self.busArriveInfo = realTimeInfo
                print(realTimeInfo)
            })
            .store(in: &self.cancellable)
    }
    
    private func findStation(in stations: [StationDTO], with arsId: String) -> StationDTO? {
        let station = stations.filter() { $0.arsID == arsId }
        return station.first
    }
}
