//
//  TokenManagerTests.swift
//  TokenManagerTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest

class TokenManagerTests: XCTestCase {
    var tokenManager: TokenManager!
    var accessKeyList: [String]!
    
    enum APIAccessKeyError: Error {
        case cannotFindAccessKey
    }

    override func setUpWithError() throws {
        self.tokenManager = TokenManager()
        self.accessKeyList = try self.loadAllAccessKeys()
        
        super.setUp()
    }

    override func tearDownWithError() throws {
        self.tokenManager = nil
        self.accessKeyList = nil
        super.tearDown()
    }
    
    func loadAllAccessKeys() throws -> [String] {
        var accessKeyList = [String]()
        
        for i in (1...TokenManager.maxTokenCount) {
            guard let accessKey = Bundle.main.infoDictionary?["API_ACCESS_KEY\(i)"] as? String else { throw APIAccessKeyError.cannotFindAccessKey }
            accessKeyList.append(accessKey)
        }
        
        return accessKeyList
    }
    
    func test_randomAccessKey_리턴_성공() {
        // given
        let expectedMinIndex = 0
        let expectedMaxIndex = 16
        
        // when then
        do {
            let randomAccessKey = try self.tokenManager.randomAccessKey()
            let index = randomAccessKey.index
            let key = randomAccessKey.key
            
            XCTAssertGreaterThanOrEqual(index, expectedMinIndex)
            XCTAssertLessThanOrEqual(index, expectedMaxIndex)
            XCTAssertTrue(self.accessKeyList.contains(key))
        } catch {
            XCTFail()
        }
    }
    
    func test_randomAccessKey_액세스키_없어_리턴_실패() {
        // given
        for i in (0..<TokenManager.maxTokenCount) {
            self.tokenManager.removeAccessKey(at: i)
        }
        
        // when then
        XCTAssertThrowsError(try self.tokenManager.randomAccessKey())
    }
}
