//
//  BusRouteViewModelTests.swift
//  BusRouteViewModelTests
//
//  Created by Kang Minsang on 2021/12/01.
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
        // given
        guard let viewModel = self.busRouteViewModel else {
            XCTFail("viewModel is nil")
            return
        }
        let expectation = XCTestExpectation()
        let answerDTO = BusRouteDTO(routeID: 100100260,
                                   busRouteName: "5524",
                                   routeType: .localLine,
                                   startStation: "난향차고지",
                                   endStation: "중앙대학교")
        
        // when
        viewModel.$header
            .receive(on: DispatchQueue.global())
            .sink { completion in
                // then
                guard case .failure(let error) = completion else { return }
                XCTFail("\(error.localizedDescription)")
                expectation.fulfill()
            } receiveValue: { header in
                guard let header = header else { return }
                // then
                XCTAssertEqual(header.routeID, answerDTO.routeID)
                XCTAssertEqual(header.busRouteName, answerDTO.busRouteName)
                XCTAssertEqual(header.routeType, answerDTO.routeType)
                XCTAssertEqual(header.startStation, answerDTO.startStation)
                XCTAssertEqual(header.endStation, answerDTO.endStation)
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_bindBodysInfo_수신_성공() throws {
        // given
        guard let viewModel = self.busRouteViewModel else {
            XCTFail("viewModel is nil")
            return
        }
        let expectation = XCTestExpectation()
        let station1 = BusStationInfo(speed: 0, afterSpeed: 44, count: 3, title: "난곡종점", description: "21809  |  04:00-22:30", transYn: "N", arsId: "21809")
        let station2 = BusStationInfo(speed: 44, afterSpeed: 29, count: 3, title: "신림복지관앞", description: "21211  |  04:00-00:18", transYn: "N", arsId: "21211")
        let station3 = BusStationInfo(speed: 29, afterSpeed: nil, count: 3, title: "난우중학교입구", description: "21210  |  04:00-22:30", transYn: "N", arsId: "21210")
        let answerStations = [station1, station2, station3]
        
        // when
        viewModel.$bodys
            .receive(on: DispatchQueue.global())
            .filter({ !$0.isEmpty })
            .sink { completion in
                // then
                guard case .failure(let error) = completion else { return }
                XCTFail("\(error.localizedDescription)")
                expectation.fulfill()
            } receiveValue: { bodys in
                // then
                XCTAssertEqual(bodys[0].arsId, answerStations[0].arsId)
                XCTAssertEqual(bodys[1].description, answerStations[1].description)
                XCTAssertEqual(bodys[2].afterSpeed, answerStations[2].afterSpeed)
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_bindBusesPosInfo_수신_성공() throws {
        // given
        guard let viewModel = self.busRouteViewModel else {
            XCTFail("viewModel is nil")
            return
        }
        let expectation = XCTestExpectation()
        let bus1 = BusPosInfo(location: CGFloat(21), number: "5255", congestion: .normal, islower: true)
        let bus2 = BusPosInfo(location: CGFloat(27) + CGFloat(("0.017" as NSString).floatValue)/CGFloat(("0.378" as NSString).floatValue), number: "5254", congestion: .normal, islower: true)
        let bus3 = BusPosInfo(location: CGFloat(31) + CGFloat(0.022)/CGFloat(0.41), number: "5252", congestion: .normal, islower: true)
        let answerBuses = [bus1, bus2, bus3]
        
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
                XCTAssertEqual(buses[0].number, answerBuses[0].number)
                XCTAssertEqual(buses[1].location, answerBuses[1].location)
                XCTAssertEqual(buses[2].congestion, answerBuses[2].congestion)
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
}
