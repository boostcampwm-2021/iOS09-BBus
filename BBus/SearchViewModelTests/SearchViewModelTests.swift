//
//  SearchViewModelTests.swift
//  SearchViewModelTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest
import Combine

class SearchViewModelTests: XCTestCase {
    enum MOCKMode {
        case success, loadBusRouteFailure, loadStationFailure, alwaysFailure
    }
    
    enum TestError: Error {
        case loadBusRouteError, loadStationListError
    }
    
    class MOCKSearchAPIUseCase: SearchAPIUsable {
        var mode: MOCKMode
        
        init(mode: MOCKMode) {
            self.mode = mode
        }
        
        func loadBusRouteList() -> AnyPublisher<[BusRouteDTO], Error> {
            switch mode {
            case .loadBusRouteFailure, .alwaysFailure:
                return Fail(error: TestError.loadBusRouteError).eraseToAnyPublisher()
            default:
                let busRouteDTOs = [ BusRouteDTO(routeID: 1, busRouteName: "1", routeType: .mainLine, startStation: "1s", endStation: "1e"),
                                     BusRouteDTO(routeID: 2, busRouteName: "2", routeType: .mainLine, startStation: "2s", endStation: "2e"),
                                     BusRouteDTO(routeID: 3, busRouteName: "3", routeType: .mainLine, startStation: "3s", endStation: "3e")]
                return Just(busRouteDTOs)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }
        
        func loadStationList() -> AnyPublisher<[StationDTO], Error> {
            switch mode {
            case .loadStationFailure, .alwaysFailure:
                return Fail(error: TestError.loadStationListError).eraseToAnyPublisher()
            default:
                let stationDTOs = [StationDTO(stationID: 1, arsID: "1", stationName: "station1"),
                                   StationDTO(stationID: 2, arsID: "2", stationName: "station2"),
                                   StationDTO(stationID: 3, arsID: "3", stationName: "station3"),
                                   StationDTO(stationID: 4, arsID: "4", stationName: "station4")]
                return Just(stationDTOs)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }
    }
    
    private var cancellables: Set<AnyCancellable>!
    private let firstBusRoute = BusSearchResult(busRouteDTO: BusRouteDTO(routeID: 1,
                                                                         busRouteName: "1",
                                                                         routeType: .mainLine,
                                                                         startStation: "1s",
                                                                         endStation: "1e"))
    private let firstStation = StationSearchResult(stationName: "station1",
                                                   arsId: "1",
                                                   stationNameMatchRanges: "station1".ranges(of: "1"),
                                                   arsIdMatchRanges: "1".ranges(of: "1"))
    
    override func setUpWithError() throws {
        self.cancellables = []
        super.setUp()
    }

    override func tearDownWithError() throws {
        self.cancellables = nil
        super.tearDown()
    }
    
    func test_bindSearchResult_성공() {
        let searchViewModel = SearchViewModel(apiUseCase: MOCKSearchAPIUseCase(mode: .success),
                                              calculateUseCase: SearchCalculateUseCase())
        let keyword = "1"
        let expectation = expectation(description: "SearchViewModel에 searchResults가 저장되는지 확인")
        let expectedResult = SearchResults(busSearchResults: [self.firstBusRoute], stationSearchResults: [self.firstStation])
        let firstExpectedBus = expectedResult.busSearchResults[0]
        let firstExpectedStation = expectedResult.stationSearchResults[0]
        
        // when then
        searchViewModel.$searchResults
            .receive(on: DispatchQueue.global())
            .dropFirst()
            .sink { searchResults in
                let firstBus = searchResults.busSearchResults[0]
                let firstStation = searchResults.stationSearchResults[0]
                
                XCTAssertEqual(searchResults.busSearchResults.count, expectedResult.busSearchResults.count)
                XCTAssertEqual(firstBus.busRouteName, firstExpectedBus.busRouteName)
                XCTAssertEqual(firstBus.routeID, firstExpectedBus.routeID)
                XCTAssertEqual(firstBus.routeType, firstExpectedBus.routeType)
                XCTAssertEqual(searchResults.stationSearchResults.count, expectedResult.stationSearchResults.count)
                XCTAssertEqual(firstStation.arsId, firstExpectedStation.arsId)
                XCTAssertEqual(firstStation.arsIdMatchRanges, firstExpectedStation.arsIdMatchRanges)
                XCTAssertEqual(firstStation.stationName, firstExpectedStation.stationName)
                XCTAssertEqual(firstStation.stationNameMatchRanges, firstExpectedStation.stationNameMatchRanges)
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        searchViewModel.configure(keyword: keyword)

        waitForExpectations(timeout: 10)
    }
    
    func test_bindSearchResult_버스와_정류소목록_둘_다_없어서_실패() {
        let searchViewModel = SearchViewModel(apiUseCase: MOCKSearchAPIUseCase(mode: .alwaysFailure),
                                              calculateUseCase: SearchCalculateUseCase())
        let keyword = "1"
        let expectation = expectation(description: "SearchViewModel에 searchResults가 저장되는지 확인")
        
        // when then
        searchViewModel.$searchResults
            .receive(on: DispatchQueue.global())
            .dropFirst()
            .sink { searchResults in
                XCTAssertTrue(searchResults.busSearchResults.isEmpty)
                XCTAssertTrue(searchResults.busSearchResults.isEmpty)
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        searchViewModel.configure(keyword: keyword)

        waitForExpectations(timeout: 10)
    }
    
    func test_bindSearchResult_버스_목록이_없어서_실패() {
        let searchViewModel = SearchViewModel(apiUseCase: MOCKSearchAPIUseCase(mode: .loadBusRouteFailure),
                                              calculateUseCase: SearchCalculateUseCase())
        let keyword = "1"
        let expectation = expectation(description: "SearchViewModel에 searchResults가 저장되는지 확인")
        let expectedResult = SearchResults(busSearchResults: [], stationSearchResults: [self.firstStation])
        let firstExpectedStation = expectedResult.stationSearchResults[0]
        let expectedError = TestError.loadBusRouteError
        
        // when then
        searchViewModel.$searchResults
            .receive(on: DispatchQueue.global())
            .dropFirst()
            .sink { searchResults in
                let firstStation = searchResults.stationSearchResults[0]
                
                XCTAssertTrue(searchResults.busSearchResults.isEmpty)
                XCTAssertEqual(searchResults.stationSearchResults.count, expectedResult.stationSearchResults.count)
                XCTAssertEqual(firstStation.arsId, firstExpectedStation.arsId)
                XCTAssertEqual(firstStation.arsIdMatchRanges, firstExpectedStation.arsIdMatchRanges)
                XCTAssertEqual(firstStation.stationName, firstExpectedStation.stationName)
                XCTAssertEqual(firstStation.stationNameMatchRanges, firstExpectedStation.stationNameMatchRanges)
                
                guard let error = searchViewModel.networkError as? TestError else { XCTFail(); return }
                switch error {
                case expectedError:
                    break
                default:
                    XCTFail()
                }
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        searchViewModel.configure(keyword: keyword)

        waitForExpectations(timeout: 10)
    }
    
    func test_bindSearchResult_정류소_목록이_없어서_실패() {
        let searchViewModel = SearchViewModel(apiUseCase: MOCKSearchAPIUseCase(mode: .loadStationFailure),
                                              calculateUseCase: SearchCalculateUseCase())
        let keyword = "1"
        let expectation = expectation(description: "SearchViewModel에 searchResults가 저장되는지 확인")
        let expectedResult = SearchResults(busSearchResults:[self.firstBusRoute], stationSearchResults: [])
        let firstExpectedBus = expectedResult.busSearchResults[0]
        let expectedError = TestError.loadStationListError
        
        // when then
        searchViewModel.$searchResults
            .receive(on: DispatchQueue.global())
            .dropFirst()
            .sink { searchResults in
                let firstBus = searchResults.busSearchResults[0]
                
                XCTAssertEqual(searchResults.busSearchResults.count, expectedResult.busSearchResults.count)
                XCTAssertEqual(firstBus.busRouteName, firstExpectedBus.busRouteName)
                XCTAssertEqual(firstBus.routeID, firstExpectedBus.routeID)
                XCTAssertEqual(firstBus.routeType, firstExpectedBus.routeType)
                XCTAssertTrue(searchResults.stationSearchResults.isEmpty)
                
                guard let error = searchViewModel.networkError as? TestError else { XCTFail(); return }
                switch error {
                case expectedError:
                    break
                default:
                    XCTFail()
                }
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        searchViewModel.configure(keyword: keyword)

        waitForExpectations(timeout: 10)
    }
}
