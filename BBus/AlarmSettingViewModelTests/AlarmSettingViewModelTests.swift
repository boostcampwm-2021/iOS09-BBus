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
        case success
    }
    
    enum TestError: Error {
        case fail, jsonError
    }

    class MOCKSearchAPIUseCase: AlarmSettingAPIUsable {
        var mode: MOCKMode
        
        init(mode: MOCKMode) {
            self.mode = mode
        }
        
        func busArriveInfoWillLoaded(stId: String, busRouteId: String, ord: String) -> AnyPublisher<ArrInfoByRouteDTO, Error> {
            return Fail(error: TestError.fail).eraseToAnyPublisher()
        }
        
        func busStationsInfoWillLoaded(busRouetId: String, arsId: String) -> AnyPublisher<[StationByRouteListDTO]?, Error> {
            return Fail(error: TestError.fail).eraseToAnyPublisher()
        }
    }
    
    private var cancellables: Set<AnyCancellable>!
    private var arrInfoByRouteDTO: ArrInfoByRouteDTO!

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
    
    func test_bindBusArriveInfo_성공() {
        
    }
}
