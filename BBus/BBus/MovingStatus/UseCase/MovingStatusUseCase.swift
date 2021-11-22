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
    static let queue = DispatchQueue(label: "MovingStatus")

    init(usecases: GetRouteListUsecase & GetStationsByRouteListUsecase & GetBusPosByRtidUsecase) {
        self.usecases = usecases
        self.cancellables = []
        self.networkError = nil
    }

    func searchHeader(busRouteId: Int) {
        Self.queue.async {
            self.usecases.getRouteList()
                .receive(on: Self.queue)
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
                .sink(receiveValue: { [weak self] header in
                    self?.header = header
                })
                .store(in: &self.cancellables)
        }
    }

    func fetchRouteList(busRouteId: Int) {
        Self.queue.async {
            self.usecases.getStationsByRouteList(busRoutedId: "\(busRouteId)")
                .receive(on: Self.queue)
                .tryMap ({ stationsByRouteList -> [StationByRouteListDTO] in
                    guard let result = BBusXMLParser().parse(dtoType: StationByRouteResult.self, xml: stationsByRouteList) else { throw BBusAPIError.wrongFormatError }
                    return result.body.itemList
                })
                .retry ({ [weak self] in
                    self?.fetchRouteList(busRouteId: busRouteId)
                }, handler: { [weak self] error in
                    self?.networkError = error
                })
                .sink(receiveValue: { [weak self] stations in
                    self?.stations = stations
                })
                .store(in: &self.cancellables)
        }
    }

    func fetchBusPosList(busRouteId: Int) {
        Self.queue.async { [weak self] in
            guard let self = self else { return }

            self.usecases.getBusPosByRtid(busRoutedId: "\(busRouteId)")
                .receive(on: Self.queue)
                .tryMap ({ busPosByRtidList -> [BusPosByRtidDTO] in
                    guard let result = BBusXMLParser().parse(dtoType: BusPosByRtidResult.self, xml: busPosByRtidList) else { throw BBusAPIError.wrongFormatError }
                    return result.body.itemList
                })
                .retry ({
                    self.fetchBusPosList(busRouteId: busRouteId)
                }, handler: { error in
                    self.networkError = error
                })
                .assign(to: \.buses, on: self)
                .store(in: &self.cancellables)
        }
    }
}
