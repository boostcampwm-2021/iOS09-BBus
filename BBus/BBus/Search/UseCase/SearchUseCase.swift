//
//  SearchBusUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class SearchUseCase {
    
    private let usecases: GetRouteListUsecase
    @Published var routeList: [BusRouteDTO]?
    private var cancellable: AnyCancellable?
    static let thread = DispatchQueue(label: "Search")
    
    init(usecases: GetRouteListUsecase) {
        self.usecases = usecases
        self.startSearch()
    }
    
    private func startSearch() {
        self.cancellable = usecases.getRouteList()
            .receive(on: Self.thread)
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                if case .failure(let error) = error {
                    print(error)
                }
            }, receiveValue: { routeList in
                self.routeList = routeList
            })
    }
    
    func searchBus(by keyword: String) -> [BusRouteDTO]? {
        guard let routeList = self.routeList else { return nil }
        if keyword == "" {
            return []
        }
        else {
            return routeList.filter { $0.busRouteName.hasPrefix(keyword) }
        }
    }
}
