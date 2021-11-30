//
//  MovingStatusViewModelTests.swift
//  MovingStatusViewModelTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest
import Foundation
import Combine

class MovingStatusViewModelTests: XCTestCase {

    var movingStatusViewModel: MovingStatusViewModel?
    var cancellables: Set<AnyCancellable> = []
    
    class DummyMovingStatusAPIUseCase: MovingStatusAPIUsable {
        func searchHeader(busRouteId: Int) -> AnyPublisher<BusRouteDTO?, Error> {
            let dummyDTO = BusRouteDTO(routeID: 100100260,
                                       busRouteName: "5524",
                                       routeType: .localLine,
                                       startStation: "난향차고지",
                                       endStation: "중앙대학교")
            return Just(dummyDTO).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func fetchRouteList(busRouteId: Int) -> AnyPublisher<[StationByRouteListDTO], Error> {
            let dummyStation1 = StationByRouteListDTO(sectionSpeed: 0,
                                                      sequence: 1,
                                                      stationName: "난곡종점",
                                                      fullSectionDistance: 0,
                                                      arsId: "21809",
                                                      beginTm: "04:00",
                                                      lastTm: "22:30",
                                                      transYn: "N")
            let dummyStation2 = StationByRouteListDTO(sectionSpeed: 44,
                                                      sequence: 2,
                                                      stationName: "신림복지관앞",
                                                      fullSectionDistance: 247,
                                                      arsId: "21211",
                                                      beginTm: "04:00",
                                                      lastTm: "00:18",
                                                      transYn: "N")
            let dummyStation3 = StationByRouteListDTO(sectionSpeed: 29,
                                                      sequence: 3,
                                                      stationName: "난우중학교입구",
                                                      fullSectionDistance: 190,
                                                      arsId: "21210",
                                                      beginTm: "04:00",
                                                      lastTm: "22:30",
                                                      transYn: "N")
            return Just([dummyStation1, dummyStation2, dummyStation3]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func fetchBusPosList(busRouteId: Int) -> AnyPublisher<[BusPosByRtidDTO], Error> {
            let dummyBus1 = BusPosByRtidDTO(busType: 1,
                                            congestion: 0,
                                            plainNumber: "서울74사5255",
                                            sectionOrder: 22,
                                            fullSectDist: "0.351",
                                            sectDist: "0",
                                            gpsY: 37.4893,
                                            gpsX: 126.927062)
            let dummyBus2 = BusPosByRtidDTO(busType: 1,
                                            congestion: 0,
                                            plainNumber: "서울74사5254",
                                            sectionOrder: 28,
                                            fullSectDist: "0.378",
                                            sectDist: "0.017",
                                            gpsY: 37.486795,
                                            gpsX: 126.947757)
            let dummyBus3 = BusPosByRtidDTO(busType: 1,
                                            congestion: 0,
                                            plainNumber: "서울74사5252",
                                            sectionOrder: 32,
                                            fullSectDist: "0.41",
                                            sectDist: "0.022",
                                            gpsY: 37.48311,
                                            gpsX: 126.954122)
            return Just([dummyBus1, dummyBus2, dummyBus3]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    override func setUpWithError() throws {
        super.setUp()
        self.movingStatusViewModel = MovingStatusViewModel(apiUseCase: DummyMovingStatusAPIUseCase(), calculateUseCase: MovingStatusCalculateUseCase(), busRouteId: 100100260, fromArsId: "21211", toArsId: "21210")
    }

    override func tearDownWithError() throws {
        super.tearDown()
        self.movingStatusViewModel = nil
    }

    func test_bindHeaderInfo_수신_성공() throws {
        // given
        guard let viewModel = self.movingStatusViewModel else {
            XCTFail("viewModel is nil")
            return
        }
        let expectation = XCTestExpectation()
        let answerHeader = BusInfo(busName: "5524", type: .localLine)
        
        // when
        viewModel.$busInfo
            .receive(on: DispatchQueue.global())
            .sink { completion in
                // then
                guard case .failure(let error) = completion else { return }
                XCTFail("\(error.localizedDescription)")
                expectation.fulfill()
            } receiveValue: { header in
                guard let header = header else { return }
                // then
                XCTAssertEqual(header.busName, answerHeader.busName)
                XCTAssertEqual(header.type, answerHeader.type)
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_bindStationsInfo_수신_성공() throws {
        // given
        guard let viewModel = self.movingStatusViewModel else {
            XCTFail("viewModel is nil")
            return
        }
        let expectation = XCTestExpectation()
        let station1 = StationInfo(speed: 44, afterSpeed: 29, count: 2, title: "신림복지관앞", sectTime: 0)
        let station2 = StationInfo(speed: 29, afterSpeed: nil, count: 2, title: "난우중학교입구", sectTime: Int(ceil(Double(11.4)/Double(21))))
        let answerStations = [station1, station2]
        
        // when
        viewModel.$stationInfos
            .receive(on: DispatchQueue.global())
            .sink { completion in
                // then
                guard case .failure(let error) = completion else { return }
                XCTFail("\(error.localizedDescription)")
                expectation.fulfill()
            } receiveValue: { stations in
                // then
                XCTAssertEqual(stations[0].title, answerStations[0].title)
                XCTAssertEqual(stations[0].speed, answerStations[0].speed)
                XCTAssertEqual(stations[1].sectTime, answerStations[1].sectTime)
                XCTAssertEqual(stations[1].afterSpeed, answerStations[1].afterSpeed)
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
