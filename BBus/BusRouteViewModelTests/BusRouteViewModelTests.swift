//
//  BusRouteViewModelTests.swift
//  BusRouteViewModelTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest
import Foundation
import Combine

class BusRouteViewModelTests: XCTestCase {
    
    var busRouteViewModel: BusRouteViewModel?
    var cancellables: Set<AnyCancellable> = []
    
    class DummyBusRouteAPIUseCase: BusRouteAPIUsable {
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
        self.busRouteViewModel = BusRouteViewModel(useCase: DummyBusRouteAPIUseCase(), busRouteId: 100100260)
    }

    override func tearDownWithError() throws {
        super.tearDown()
        self.busRouteViewModel = nil
    }

    func test_bindHeaderInfo_수신_성공() throws {
        guard let viewModel = self.busRouteViewModel else {
            XCTFail("viewModel is nil")
            return
        }
        
        let expectation = XCTestExpectation()
        
        viewModel.$header
            .receive(on: DispatchQueue.global())
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                XCTFail("\(error.localizedDescription)")
                expectation.fulfill()
            } receiveValue: { header in
                dump(header)
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_bindBodysInfo_수신_성공() throws {
        guard let viewModel = self.busRouteViewModel else {
            XCTFail("viewModel is nil")
            return
        }
        
        let expectation = XCTestExpectation()
        
        viewModel.$bodys
            .receive(on: DispatchQueue.global())
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                XCTFail("\(error.localizedDescription)")
                expectation.fulfill()
            } receiveValue: { bodys in
                dump(bodys)
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
