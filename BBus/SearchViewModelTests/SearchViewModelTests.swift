//
//  SearchViewModelTests.swift
//  SearchViewModelTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest
import Combine

class SearchViewModelTests: XCTestCase {
    var searchViewModel: SearchViewModel!
    
    class DummySearchAPIUseCase: SearchAPIUsable {
        func loadBusRouteList() -> AnyPublisher<[BusRouteDTO], Error> {
            return CurrentValueSubject<[BusRouteDTO], Error>([])
                .eraseToAnyPublisher()
        }
        
        func loadStationList() -> AnyPublisher<[StationDTO], Error> {
            return CurrentValueSubject<[StationDTO], Error>([])
                .eraseToAnyPublisher()
        }
    }
    
    class DummySearchCalculateUseCase: SearchCalculatable {
        func searchStation(by keyword: String, at stationList: [StationDTO]) -> [StationSearchResult] {
            return []
        }
        
        func searchBus(by keyword: String, at routeList: [BusRouteDTO]) -> [BusSearchResult] {
            return []
        }
    }

    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }
    
}
