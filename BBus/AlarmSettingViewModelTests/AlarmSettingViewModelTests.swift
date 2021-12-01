//
//  AlarmSettingViewModelTests.swift
//  AlarmSettingViewModelTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest
import Combine

class AlarmSettingViewModelTests: XCTestCase {
    enum MOCKMode {
        case success, failure
    }
    
    enum TestError: Error {
        case fail, jsonError
    }

    class MOCKAlarmSettingAPIUseCase: AlarmSettingAPIUsable {
        var mode: MOCKMode
        var arrInfoByRouteDTO: ArrInfoByRouteDTO
        
        init(mode: MOCKMode, arrInfoByRouteDTO: ArrInfoByRouteDTO) {
            self.mode = mode
            self.arrInfoByRouteDTO = arrInfoByRouteDTO
        }
        
        func busArriveInfoWillLoaded(stId: String, busRouteId: String, ord: String) -> AnyPublisher<ArrInfoByRouteDTO, Error> {
            switch mode {
            case .success:
                return Just(self.arrInfoByRouteDTO)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            case .failure:
                return Fail(error: TestError.fail).eraseToAnyPublisher()
            }
            
        }
        
        func busStationsInfoWillLoaded(busRouetId: String, arsId: String) -> AnyPublisher<[StationByRouteListDTO]?, Error> {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    private var cancellables: Set<AnyCancellable>!
    private var arrInfoByRouteDTO: ArrInfoByRouteDTO!
    private let firstArriveInfo = AlarmSettingBusArriveInfo(busArriveRemainTime: "곧 도착",
                                                            congestion: 3,
                                                            currentStation: "모두의학교.금천문화예술정보학교",
                                                            plainNumber: "서울71사1535",
                                                            vehicleId: 117020066)
    private let secondArriveInfo = AlarmSettingBusArriveInfo(busArriveRemainTime: "7분9초후[3번째 전]",
                                                             congestion: 4,
                                                             currentStation: "호림박물관",
                                                             plainNumber: "서울71사1519",
                                                             vehicleId: 117020207)

    override func setUpWithError() throws {
        guard let url = Bundle.init(identifier: "com.boostcamp.ios-009.AlarmSettingViewModelTests")?
                .url(forResource: "MOCKArrInfo", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let arrInfoByRouteDTO = try? JSONDecoder().decode(ArrInfoByRouteDTO.self, from: data) else { throw TestError.jsonError }
        
        self.cancellables = []
        self.arrInfoByRouteDTO = arrInfoByRouteDTO
        super.setUp()
    }

    override func tearDownWithError() throws {
        self.cancellables = nil
        self.arrInfoByRouteDTO = nil
        super.tearDown()
    }
    
    func test_refresh_성공() {
        let MOCCKAlarmSettingUseCase = MOCKAlarmSettingAPIUseCase(mode: .success, arrInfoByRouteDTO: self.arrInfoByRouteDTO)
        let alarmSettingVieWModel = AlarmSettingViewModel(apiUseCase: MOCCKAlarmSettingUseCase,
                                                          calculateUseCase: AlarmSettingCalculateUseCase(),
                                                          stationId: 1,
                                                          busRouteId: 1,
                                                          stationOrd: 1,
                                                          arsId: "11111",
                                                          routeType: RouteType.mainLine,
                                                          busName: "11")
        let expectation = expectation(description: "AlarmSettingViewModel에 busArriveInfos가 저장되는지 확인")
        let expectedFirstArriveInfo = self.firstArriveInfo
        let expectedSecondArriveInfo = self.secondArriveInfo
        let expectedResult = AlarmSettingBusArriveInfos(arriveInfos: [expectedFirstArriveInfo, expectedSecondArriveInfo], changedByTimer: false)
        
        alarmSettingVieWModel.refresh()
        alarmSettingVieWModel.$busArriveInfos
            .receive(on: DispatchQueue.global())
            .filter { $0.count != 0 }
            .sink { busArriveInfos in
                let firstArriveInfo = busArriveInfos.arriveInfos[0]
                let secondArriveInfo = busArriveInfos.arriveInfos[1]
                
                XCTAssertEqual(busArriveInfos.count, expectedResult.count)
                XCTAssertEqual(firstArriveInfo.congestion, expectedFirstArriveInfo.congestion)
                XCTAssertEqual(firstArriveInfo.arriveRemainTime?.message, expectedFirstArriveInfo.arriveRemainTime?.message)
                XCTAssertEqual(firstArriveInfo.arriveRemainTime?.seconds, expectedFirstArriveInfo.arriveRemainTime?.seconds)
                XCTAssertEqual(firstArriveInfo.currentStation, expectedFirstArriveInfo.currentStation)
                XCTAssertEqual(firstArriveInfo.estimatedArrivalTime, expectedFirstArriveInfo.estimatedArrivalTime)
                XCTAssertEqual(firstArriveInfo.relativePosition, expectedFirstArriveInfo.relativePosition)
                XCTAssertEqual(firstArriveInfo.vehicleId, expectedFirstArriveInfo.vehicleId)
                XCTAssertEqual(firstArriveInfo.plainNumber, expectedFirstArriveInfo.plainNumber)
                XCTAssertEqual(secondArriveInfo.congestion, expectedSecondArriveInfo.congestion)
                XCTAssertEqual(secondArriveInfo.arriveRemainTime?.message, expectedSecondArriveInfo.arriveRemainTime?.message)
                XCTAssertEqual(secondArriveInfo.arriveRemainTime?.seconds, expectedSecondArriveInfo.arriveRemainTime?.seconds)
                XCTAssertEqual(secondArriveInfo.currentStation, expectedSecondArriveInfo.currentStation)
                XCTAssertEqual(secondArriveInfo.estimatedArrivalTime, expectedSecondArriveInfo.estimatedArrivalTime)
                XCTAssertEqual(secondArriveInfo.relativePosition, expectedSecondArriveInfo.relativePosition)
                XCTAssertEqual(secondArriveInfo.vehicleId, expectedSecondArriveInfo.vehicleId)
                XCTAssertEqual(secondArriveInfo.plainNumber, expectedSecondArriveInfo.plainNumber)
                XCTAssertFalse(busArriveInfos.changedByTimer)
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_refresh_arriveInfo가_에러를_리턴하여_실패() {
        let MOCCKAlarmSettingUseCase = MOCKAlarmSettingAPIUseCase(mode: .failure, arrInfoByRouteDTO: self.arrInfoByRouteDTO)
        let alarmSettingVieWModel = AlarmSettingViewModel(apiUseCase: MOCCKAlarmSettingUseCase,
                                                          calculateUseCase: AlarmSettingCalculateUseCase(),
                                                          stationId: 1,
                                                          busRouteId: 1,
                                                          stationOrd: 1,
                                                          arsId: "11111",
                                                          routeType: RouteType.mainLine,
                                                          busName: "11")
        let expectation = expectation(description: "AlarmSettingViewModel에 busArriveInfos가 저장되는지 확인")
        
        alarmSettingVieWModel.refresh()
        alarmSettingVieWModel.$networkError
            .receive(on: DispatchQueue.global())
            .compactMap { $0 }
            .sink { error in
                guard let error = error as? TestError else { XCTFail(); return; }
                switch error {
                case .fail:
                    expectation.fulfill()
                default:
                    XCTFail()
                }
            }
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10)
    }
}
