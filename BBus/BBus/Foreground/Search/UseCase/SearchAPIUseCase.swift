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
    
    private let usecases: GetRouteListUsecase & GetStationListUsecase
    private var cancellables: Set<AnyCancellable>
    @Published var networkError: Error?
    
    init(usecases: GetRouteListUsecase & GetStationListUsecase) {
        self.usecases = usecases
        self.cancellables = []
    }
    
    func loadBusRouteList() -> AnyPublisher<[BusRouteDTO], Error> {
        self.usecases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func loadStationList() -> AnyPublisher<[StationDTO], Error> {
        self.usecases.getStationList()
            .decode(type: [StationDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
