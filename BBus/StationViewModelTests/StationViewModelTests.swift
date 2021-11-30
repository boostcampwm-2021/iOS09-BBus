//
//  StationViewModelTests.swift
//  StationViewModelTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest
import Combine

class StationViewModelTests: XCTestCase {
    
    enum TestError: Error {
        case unknownError, urlError, dataError
        
        func publisher<T>() -> AnyPublisher<T, Error> {
            let publisher = CurrentValueSubject<T?, Error>(nil)
            publisher.send(completion: .failure(self))
            return publisher.compactMap({$0})
                .eraseToAnyPublisher()
        }
    }
    
    struct MOCKStationAPIUseCase: StationAPIUsable {
        func loadStationList() -> AnyPublisher<[StationDTO], Error> {
            let stationDTOs = [StationDTO(stationID: 1, arsID: "1", stationName: "station1"),
                               StationDTO(stationID: 2, arsID: "2", stationName: "station2"),
                               StationDTO(stationID: 3, arsID: "3", stationName: "station3"),
                               StationDTO(stationID: 4, arsID: "4", stationName: "station4")]
            return stationDTOs.publisher
                .setFailureType(to: Error.self)
                .collect()
                .eraseToAnyPublisher()
        }
        
        func refreshInfo(about arsId: String) -> AnyPublisher<[StationByUidItemDTO], Error> {
            guard let url = Bundle.init(identifier: "com.boostcamp.ios-009.StationViewModelTests")?.url(forResource: "DummyJsonStringStationByUidItemDTO", withExtension: "json") else {
                return TestError.urlError.publisher()
            }
            if let data = try? Data(contentsOf: url),
               let stationByUidDTOs = (try? JSONDecoder().decode(StationByUidItemResult.self, from: data))?.msgBody.itemList {
                return stationByUidDTOs.publisher
                    .setFailureType(to: Error.self)
                    .collect()
                    .eraseToAnyPublisher()
            } else {
                return TestError.dataError.publisher()
            }
        }
        
        func add(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
            let data = try? PropertyListEncoder().encode(favoriteItem)
            return data.publisher
                .setFailureType(to: Error.self)
                .compactMap({$0})
                .eraseToAnyPublisher()
        }
        
        func remove(favoriteItem: FavoriteItemDTO) -> AnyPublisher<Data, Error> {
            self.add(favoriteItem: favoriteItem)
        }
        
        func getFavoriteItems() -> AnyPublisher<[FavoriteItemDTO], Error> {
            let favoriteItemsDTOs = [FavoriteItemDTO(stId: "1", busRouteId: "1", ord: "1", arsId: "1"),
                                     FavoriteItemDTO(stId: "1", busRouteId: "3", ord: "2", arsId: "4"),
                                     FavoriteItemDTO(stId: "1", busRouteId: "1", ord: "1", arsId: "1"),
                                     FavoriteItemDTO(stId: "3", busRouteId: "2", ord: "2", arsId: "2")]
            return favoriteItemsDTOs.publisher
                .setFailureType(to: Error.self)
                .collect()
                .eraseToAnyPublisher()
        }
        
        func loadRoute() -> AnyPublisher<[BusRouteDTO], Error> {
            let busRouteDTOs = [BusRouteDTO(routeID: 100100496,
                                            busRouteName: "bus1",
                                            routeType: RouteType.broadArea,
                                            startStation: "station1",
                                            endStation: "station5"),
                                BusRouteDTO(routeID: 2,
                                            busRouteName: "bus2",
                                            routeType: RouteType.broadArea,
                                            startStation: "station2",
                                            endStation: "station100"),
                                BusRouteDTO(routeID: 107000002,
                                            busRouteName: "bus3",
                                            routeType: RouteType.circulation,
                                            startStation: "station1",
                                            endStation: "station5")]
            return busRouteDTOs.publisher
                .setFailureType(to: Error.self)
                .collect()
                .eraseToAnyPublisher()
        }
        
        
    }
    
    private let timeout: TimeInterval = 10
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_bindStationInfo_정상_할당_확인() {
        // given
        let stationViewModel = StationViewModel(apiUseCase: MOCKStationAPIUseCase(),
                                                calculateUseCase: StationCalculateUseCase(),
                                                arsId: "1")
        let expectation = self.expectation(description: "StationViewModel에 stationInfo가 정상적으로 왔는지 확인")
        let expectationResult = StationDTO(stationID: 1, arsID: "1", stationName: "station1")
        
        // when
        stationViewModel.$stationInfo
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { [weak expectation] _ in
                expectation?.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: timeout)
        
        // then
        XCTAssertEqual(stationViewModel.stationInfo?.arsID, expectationResult.arsID)
        XCTAssertEqual(stationViewModel.stationInfo?.stationName, expectationResult.stationName)
        XCTAssertEqual(stationViewModel.stationInfo?.stationID, expectationResult.stationID)
    }

    func test_bindStationInfo_일치하는_Station_정보가_없는_경우() {
        // given
        let stationViewModel = StationViewModel(apiUseCase: MOCKStationAPIUseCase(),
                                                calculateUseCase: StationCalculateUseCase(),
                                                arsId: "0")
        let expectation = self.expectation(description: "일치하는 stationInfo가 없는 경우 에러를 반환하는지 확인")
        var error: Error? = nil
        
        // when
        stationViewModel.$error
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { [weak expectation] result in
                error = result
                expectation?.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: timeout)
        
        // then
        XCTAssertNotNil(error)
    }
    
    func test_bindFavoriteItems_정상_할당_확인() {
        // given
        let stationViewModel = StationViewModel(apiUseCase: MOCKStationAPIUseCase(),
                                                calculateUseCase: StationCalculateUseCase(),
                                                arsId: "1")
        let expectation = self.expectation(description: "StationViewModel에 favoriteItems가 정상적으로 왔는지 확인")
        let expectationResult = [FavoriteItemDTO(stId: "1", busRouteId: "1", ord: "1", arsId: "1"),
                                 FavoriteItemDTO(stId: "1", busRouteId: "1", ord: "1", arsId: "1")]
        
        // when
        stationViewModel.$favoriteItems
            .dropFirst()
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { [weak expectation] _ in
                expectation?.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: timeout)
        
        // then
        XCTAssertEqual(stationViewModel.favoriteItems?.count ?? 0, expectationResult.count)
        stationViewModel.favoriteItems?.enumerated().forEach({ index, favoriteItem in
            XCTAssertEqual(favoriteItem.arsId, expectationResult[index].arsId)
            XCTAssertEqual(favoriteItem.busRouteId, expectationResult[index].busRouteId)
            XCTAssertEqual(favoriteItem.ord, expectationResult[index].ord)
            XCTAssertEqual(favoriteItem.stId, expectationResult[index].stId)
        })
    }
    
    func test_refresh_nextStation_정상_할당_확인() {
        // given
        let stationViewModel = StationViewModel(apiUseCase: MOCKStationAPIUseCase(),
                                                calculateUseCase: StationCalculateUseCase(),
                                                arsId: "1")
        let expectation = self.expectation(description: "StationViewModel에 nextStation가 정상적으로 왔는지 확인")
        let expectationResult = "송파와이즈더샵.엠코타운센트로엘"
        
        // when
        stationViewModel.$nextStation
            .dropFirst()
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { [weak expectation] _ in
                expectation?.fulfill()
            })
            .store(in: &self.cancellables)
        stationViewModel.refresh()
        
        waitForExpectations(timeout: timeout)
        
        // then
        XCTAssertEqual(stationViewModel.nextStation, expectationResult)
    }
    
    func test_refresh_activeBuses_정상_할당_확인() {
        // given
        let stationViewModel = StationViewModel(apiUseCase: MOCKStationAPIUseCase(),
                                                calculateUseCase: StationCalculateUseCase(),
                                                arsId: "1")
        let expectation = self.expectation(description: "StationViewModel에 activeBuses가 정상적으로 왔는지 확인")
        let busArriveInfo: BusArriveInfo
        busArriveInfo.nextStation = "송파와이즈더샵.엠코타운센트로엘"
        busArriveInfo.busRouteId = 100100496
        busArriveInfo.busNumber = "333"
        busArriveInfo.routeType = BBusRouteType.gansun
        busArriveInfo.stationOrd = 7
        busArriveInfo.firstBusArriveRemainTime = BusRemainTime(arriveRemainTime: "2분20초")
        busArriveInfo.firstBusRelativePosition = "1번째전"
        busArriveInfo.firstBusCongestion = BusCongestion(rawValue: 0)
        busArriveInfo.secondBusArriveRemainTime = BusRemainTime(arriveRemainTime: "7분20초")
        busArriveInfo.secondBusRelativePosition = "3번째전"
        busArriveInfo.secondBusCongestion = BusCongestion(rawValue: 0)
        
        let expectationResult = [BBusRouteType.gansun: BusArriveInfos(infos: [busArriveInfo])]
        
        // when
        stationViewModel.$busKeys
            .dropFirst()
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { [weak expectation] _ in
                expectation?.fulfill()
            })
            .store(in: &self.cancellables)
        stationViewModel.refresh()
        
        waitForExpectations(timeout: timeout)
        
        // then
        XCTAssertEqual(stationViewModel.activeBuses.count, expectationResult.count)
        stationViewModel.activeBuses.forEach({ key, info in
            guard info.count() == expectationResult[key]?.count() ?? 0 else { return XCTFail() }
            for i in 0..<info.count() {
                XCTAssertEqual(info[i]?.nextStation, expectationResult[key]?[i]?.nextStation)
                XCTAssertEqual(info[i]?.busRouteId, expectationResult[key]?[i]?.busRouteId)
                XCTAssertEqual(info[i]?.busNumber, expectationResult[key]?[i]?.busNumber)
                XCTAssertEqual(info[i]?.routeType, expectationResult[key]?[i]?.routeType)
                XCTAssertEqual(info[i]?.stationOrd, expectationResult[key]?[i]?.stationOrd)
                XCTAssertEqual(info[i]?.firstBusArriveRemainTime?.message, expectationResult[key]?[i]?.firstBusArriveRemainTime?.message)
                XCTAssertEqual(info[i]?.firstBusArriveRemainTime?.seconds, expectationResult[key]?[i]?.firstBusArriveRemainTime?.seconds)
                XCTAssertEqual(info[i]?.firstBusRelativePosition, expectationResult[key]?[i]?.firstBusRelativePosition)
                XCTAssertEqual(info[i]?.firstBusCongestion, expectationResult[key]?[i]?.firstBusCongestion)
                XCTAssertEqual(info[i]?.secondBusArriveRemainTime?.message, expectationResult[key]?[i]?.secondBusArriveRemainTime?.message)
                XCTAssertEqual(info[i]?.secondBusArriveRemainTime?.seconds, expectationResult[key]?[i]?.secondBusArriveRemainTime?.seconds)
                XCTAssertEqual(info[i]?.secondBusRelativePosition, expectationResult[key]?[i]?.secondBusRelativePosition)
                XCTAssertEqual(info[i]?.secondBusCongestion, expectationResult[key]?[i]?.secondBusCongestion)
            }
        })
    }
    
    func test_refresh_inActiveBuses_정상_할당_확인() {
        // given
        let stationViewModel = StationViewModel(apiUseCase: MOCKStationAPIUseCase(),
                                                calculateUseCase: StationCalculateUseCase(),
                                                arsId: "1")
        let expectation = self.expectation(description: "StationViewModel에 inActiveBuses가 정상적으로 왔는지 확인")
        let busArriveInfo: BusArriveInfo
        busArriveInfo.nextStation = "서울위례별초교"
        busArriveInfo.busRouteId = 107000002
        busArriveInfo.busNumber = "343"
        busArriveInfo.routeType = BBusRouteType.jisun
        busArriveInfo.stationOrd = 7
        busArriveInfo.firstBusArriveRemainTime = nil
        busArriveInfo.firstBusRelativePosition = nil
        busArriveInfo.firstBusCongestion = nil
        busArriveInfo.secondBusArriveRemainTime = nil
        busArriveInfo.secondBusRelativePosition = nil
        busArriveInfo.secondBusCongestion = nil
        
        let expectationResult = [BBusRouteType.jisun: BusArriveInfos(infos: [busArriveInfo])]
        
        // when
        stationViewModel.$busKeys
            .dropFirst()
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { [weak expectation] _ in
                expectation?.fulfill()
            })
            .store(in: &self.cancellables)
        stationViewModel.refresh()
        
        waitForExpectations(timeout: timeout)
        
        // then
        XCTAssertEqual(stationViewModel.inActiveBuses.count, expectationResult.count)
        stationViewModel.inActiveBuses.forEach({ key, info in
            guard info.count() == expectationResult[key]?.count() ?? 0 else { return XCTFail() }
            for i in 0..<info.count() {
                XCTAssertEqual(info[i]?.nextStation, expectationResult[key]?[i]?.nextStation)
                XCTAssertEqual(info[i]?.busRouteId, expectationResult[key]?[i]?.busRouteId)
                XCTAssertEqual(info[i]?.busNumber, expectationResult[key]?[i]?.busNumber)
                XCTAssertEqual(info[i]?.routeType, expectationResult[key]?[i]?.routeType)
                XCTAssertEqual(info[i]?.stationOrd, expectationResult[key]?[i]?.stationOrd)
                XCTAssertEqual(info[i]?.firstBusArriveRemainTime?.message, expectationResult[key]?[i]?.firstBusArriveRemainTime?.message)
                XCTAssertEqual(info[i]?.firstBusArriveRemainTime?.seconds, expectationResult[key]?[i]?.firstBusArriveRemainTime?.seconds)
                XCTAssertEqual(info[i]?.firstBusRelativePosition, expectationResult[key]?[i]?.firstBusRelativePosition)
                XCTAssertEqual(info[i]?.firstBusCongestion, expectationResult[key]?[i]?.firstBusCongestion)
                XCTAssertEqual(info[i]?.secondBusArriveRemainTime?.message, expectationResult[key]?[i]?.secondBusArriveRemainTime?.message)
                XCTAssertEqual(info[i]?.secondBusArriveRemainTime?.seconds, expectationResult[key]?[i]?.secondBusArriveRemainTime?.seconds)
                XCTAssertEqual(info[i]?.secondBusRelativePosition, expectationResult[key]?[i]?.secondBusRelativePosition)
                XCTAssertEqual(info[i]?.secondBusCongestion, expectationResult[key]?[i]?.secondBusCongestion)
            }
        })
    }
    
    func test_refresh_busKeys_정상_할당_확인() {
        // given
        let stationViewModel = StationViewModel(apiUseCase: MOCKStationAPIUseCase(),
                                                calculateUseCase: StationCalculateUseCase(),
                                                arsId: "1")
        let expectation = self.expectation(description: "StationViewModel에 activeBuses가 정상적으로 왔는지 확인")
        let expectationResult = BusSectionKeys(keys: [BBusRouteType.gansun, BBusRouteType.jisun])
        
        // when
        stationViewModel.$busKeys
            .dropFirst()
            .sink(receiveCompletion: { _ in
                return
            }, receiveValue: { [weak expectation] _ in
                expectation?.fulfill()
            })
            .store(in: &self.cancellables)
        stationViewModel.refresh()
        
        waitForExpectations(timeout: timeout)
        
        // then
        guard stationViewModel.busKeys.count() == expectationResult.count() else { return XCTFail() }
        for i in 0..<stationViewModel.busKeys.count() {
            XCTAssertEqual(stationViewModel.busKeys[i], expectationResult[i])
        }
    }
}
