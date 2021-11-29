//
//  MovingStatusUseCase.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

final class MovingStatusUsecase {

    private let usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase
    @Published var header: BusRouteDTO?
    @Published var buses: [BusPosByRtidDTO] = []
    @Published var stations: [StationByRouteListDTO] = []
    @Published var networkError: Error?

    private var cancellables: Set<AnyCancellable>

    init(usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase) {
        self.usecases = usecases
        self.cancellables = []
        self.networkError = nil
    }

    func searchHeader(busRouteId: Int) {
        self.usecases.getRouteList()
            .decode(type: [BusRouteDTO].self, decoder: JSONDecoder())
            .tryMap({ routeList in
                let headers = routeList.filter({ $0.routeID == busRouteId })
                if let header = headers.first {
                    return header
                }
                else {
                    throw BBusAPIError.wrongFormatError
                }
            })
            .retry({ [weak self] in
                self?.searchHeader(busRouteId: busRouteId)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$header)
    }

    func fetchRouteList(busRouteId: Int) {
        self.usecases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
            .decode(type: StationByRouteResult.self, decoder: JSONDecoder())
            .retry ({ [weak self] in
                self?.fetchRouteList(busRouteId: busRouteId)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .map({ item in
                item.msgBody.itemList
            })
            .assign(to: &self.$stations)
    }

    func fetchBusPosList(busRouteId: Int) {
        self.usecases.getBusPosByRtid(busRoutedId: "\(busRouteId)")
            .decode(type: BusPosByRtidResult.self, decoder: JSONDecoder())
            .tryMap ({ item in
                return item.msgBody.itemList
            })
            .retry ({ [weak self] in
                self?.fetchBusPosList(busRouteId: busRouteId)
            }, handler: { [weak self] error in
                self?.networkError = error
            })
            .assign(to: &self.$buses)
    }
}
