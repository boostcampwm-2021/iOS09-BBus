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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
