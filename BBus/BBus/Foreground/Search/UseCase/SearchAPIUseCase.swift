//
//  SearchAPIUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

protocol SearchAPIUsable: BaseUseCase {
    func loadBusRouteList() -> AnyPublisher<[BusRouteDTO], Error>
    func loadStationList() -> AnyPublisher<[StationDTO], Error>
}

final class SearchAPIUseCase: SearchAPIUsable {
    
    private let useCases: GetRouteListUsable & GetStationListUsable
    private var cancellables: Set<AnyCancellable>
    @Published var networkError: Error?
    
    init(useCases: GetRouteListUsable & GetStationListUsable) {
        self.useCases = useCases
        self.cancellables = []
    }
    
    func loadBusRouteList() -> AnyPublisher<[BusRouteDTO], Error> {
        self.useCases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func loadStationList() -> AnyPublisher<[StationDTO], Error> {
        self.useCases.getStationList()
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
