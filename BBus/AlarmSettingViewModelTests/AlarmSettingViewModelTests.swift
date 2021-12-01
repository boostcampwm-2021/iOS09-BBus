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
