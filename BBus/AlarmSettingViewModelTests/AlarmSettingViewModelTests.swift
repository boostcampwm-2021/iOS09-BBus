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
        case fail
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

    override func setUpWithError() throws {
        self.cancellables = []
        super.setUp()
    }

    override func tearDownWithError() throws {
        self.cancellables = nil
        super.tearDown()
    }
}
