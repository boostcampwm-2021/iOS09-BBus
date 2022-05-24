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
                                            sectionOrder: 0,
                                            fullSectDist: "0.351",
                                            sectDist: "0",
                                            gpsY: 37.4893,
                                            gpsX: 126.927062)
            let dummyBus2 = BusPosByRtidDTO(busType: 1,
                                            congestion: 0,
                                            plainNumber: "서울74사5254",
                                            sectionOrder: 2,
                                            fullSectDist: "0.378",
                                            sectDist: "0.017",
                                            gpsY: 37.486795,
                                            gpsX: 126.947757)
            let dummyBus3 = BusPosByRtidDTO(busType: 1,
                                            congestion: 0,
                                            plainNumber: "서울74사5252",
                                            sectionOrder: 4,
                                            fullSectDist: "0.41",
                                            sectDist: "0.022",
                                            gpsY: 37.48311,
                                            gpsX: 126.954122)
            return Just([dummyBus1, dummyBus2, dummyBus3]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func test_bindHeaderInfo_수신_성공() throws {
        // given
        let viewModel = MovingStatusViewModel(apiUseCase: DummyMovingStatusAPIUseCase(), calculateUseCase: MovingStatusCalculateUseCase(), busRouteId: 100100260, fromArsId: "21211", toArsId: "21210")
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
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_bindStationsInfo_수신_성공() throws {
        // given
        let viewModel = MovingStatusViewModel(apiUseCase: DummyMovingStatusAPIUseCase(), calculateUseCase: MovingStatusCalculateUseCase(), busRouteId: 100100260, fromArsId: "21211", toArsId: "21210")
        let expectation = XCTestExpectation()
        let station1 = StationInfo(speed: 44, afterSpeed: 29, count: 2, title: "신림복지관앞", sectTime: 0)
        let station2 = StationInfo(speed: 29, afterSpeed: nil, count: 2, title: "난우중학교입구", sectTime: Int(ceil(Double(11.4)/Double(21))))
        let answerStations = [station1, station2]
        
        // when
        viewModel.$stationInfos
            .receive(on: DispatchQueue.global())
            .filter({ !$0.isEmpty })
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
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_bindBusesPosInfo_수신_성공() throws {
        // given
        let viewModel = MovingStatusViewModel(apiUseCase: DummyMovingStatusAPIUseCase(), calculateUseCase: MovingStatusCalculateUseCase(), busRouteId: 100100260, fromArsId: "21211", toArsId: "21210")
        let expectation = XCTestExpectation()
        let targetBus = BusPosByRtidDTO(busType: 1,
                                        congestion: 0,
                                        plainNumber: "서울74사5254",
                                        sectionOrder: 2,
                                        fullSectDist: "0.378",
                                        sectDist: "0.017",
                                        gpsY: 37.486795,
                                        gpsX: 126.947757)
        let answerBuses = [targetBus]
        
        // when
        viewModel.$buses
            .receive(on: DispatchQueue.global())
            .filter({ !$0.isEmpty })
            .sink { completion in
                // then
                guard case .failure(let error) = completion else { return }
                XCTFail("\(error.localizedDescription)")
                expectation.fulfill()
            } receiveValue: { buses in
                // then
                XCTAssertEqual(buses[0].congestion, answerBuses[0].congestion)
                XCTAssertEqual(buses[0].plainNumber, answerBuses[0].plainNumber)
                XCTAssertEqual(buses[0].sectionOrder, answerBuses[0].sectionOrder)
                XCTAssertEqual(buses[0].gpsX, answerBuses[0].gpsX)
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_updateRemainingStation() throws {
        // given
        let viewModel = MovingStatusViewModel(apiUseCase: DummyMovingStatusAPIUseCase(), calculateUseCase: MovingStatusCalculateUseCase(), busRouteId: 100100260, fromArsId: "21211", toArsId: "21210")
        let expectation = XCTestExpectation()
        let answer: Int? = 1
        
        // when
        viewModel.$remainingTime
            .receive(on: DispatchQueue.global())
            .filter({ $0 != nil })
            .sink { completion in
                // then
                guard case .failure(let error) = completion else { return }
                XCTFail("\(error.localizedDescription)")
                expectation.fulfill()
            } receiveValue: { remainStation in
                // then
                XCTAssertEqual(remainStation, answer)
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_updateBoardBus() throws {
//        // given
//        let viewModel = MovingStatusViewModel(apiUseCase: DummyMovingStatusAPIUseCase(), calculateUseCase: MovingStatusCalculateUseCase(), busRouteId: 100100260, fromArsId: "21211", toArsId: "21210")
//        let expectation = XCTestExpectation()
//        let targetBus = BoardedBus(location: CGFloat(Double(("0.017" as NSString).floatValue)/Double(("0.378" as NSString).floatValue)), remainStation: 1)
//
//        // when
//        viewModel.$boardedBus
//            .receive(on: DispatchQueue.global())
//            .filter({ $0 != nil })
//            .sink { completion in
//                // then
//                guard case .failure(let error) = completion else { return }
//                XCTFail("\(error.localizedDescription)")
//                expectation.fulfill()
//            } receiveValue: { boardedBus in
//                guard let boardedBus = boardedBus else { return }
//                // then
//                XCTAssertEqual(boardedBus.remainStation, targetBus.remainStation)
//                XCTAssertEqual(boardedBus.location, targetBus.location)
//                expectation.fulfill()
//            }
//            .store(in: &self.cancellables)
//        sleep(1)
//        viewModel.findBoardBus(gpsY: 37.486795, gpsX: 126.947757)
//
//        wait(for: [expectation], timeout: 10)
    }
    
    func test_remainintTime() throws {
        // given
        let viewModel = MovingStatusViewModel(apiUseCase: DummyMovingStatusAPIUseCase(), calculateUseCase: MovingStatusCalculateUseCase(), busRouteId: 100100260, fromArsId: "21211", toArsId: "21210")
        let expectation = XCTestExpectation()
        let answer: Int? = 1
        
        // when
        viewModel.$remainingTime
            .receive(on: DispatchQueue.global())
            .filter({ $0 != nil })
            .sink { completion in
                // then
                guard case .failure(let error) = completion else { return }
                XCTFail("\(error.localizedDescription)")
                expectation.fulfill()
            } receiveValue: { remainingTime in
                // then
                XCTAssertEqual(remainingTime, answer)
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        sleep(1)
        viewModel.findBoardBus(gpsY: 37.486795, gpsX: 126.947757)
        
        wait(for: [expectation], timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let viewModel = MovingStatusViewModel(apiUseCase: DummyMovingStatusAPIUseCase(), calculateUseCase: MovingStatusCalculateUseCase(), busRouteId: 100100260, fromArsId: "21211", toArsId: "21210")
        measure {
            // Put the code you want to measure the time of here.
            (0..<10).forEach() { _ in
                viewModel.updateAPI()
            }
        }
    }

}
