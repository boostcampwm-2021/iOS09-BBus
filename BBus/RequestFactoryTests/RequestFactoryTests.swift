//
//  RequestFactoryTests.swift
//  RequestFactoryTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest

class RequestFactoryTests: XCTestCase {

    private var requestFactory: Requestable?
    
    override func setUpWithError() throws {
        super.setUp()
        self.requestFactory = RequestFactory()
    }

    override func tearDownWithError() throws {
        super.tearDown()
        self.requestFactory = nil
    }

    func test_request_파라미터2개_생성_일치() throws {
        // given
        let mockUrl = "http://ws.bus.go.kr/testUrl"
        let mockAccessKey = "uAtMsUVNMLIM%2FM9%3D%3D"
        let mockParam = ["stId": "10001", "busRouteId": "1001001"]
        let answer1 = URL(string: "http://ws.bus.go.kr/testUrl?stId=10001&busRouteId=1001001&serviceKey=uAtMsUVNMLIM%2FM9%3D%3D")
        let answer2 = URL(string: "http://ws.bus.go.kr/testUrl?busRouteId=1001001&stId=10001&serviceKey=uAtMsUVNMLIM%2FM9%3D%3D")
        let answers = [answer1, answer2]
        
        // when
        guard let requestResult = self.requestFactory?.request(url: mockUrl, accessKey: mockAccessKey, params: mockParam) else {
            XCTFail("request result is nil")
            return
        }
        
        // then
        XCTAssertNotNil(requestResult)
        XCTAssertTrue(answers.contains(requestResult.url))
    }

    func test_request_파라미터3개_생성_일치() throws {
        //given
        let mockUrl = "http://www.BBus.test"
        let mockAccessKey = "uAtMsUVNMLIM%2FM9%3D%3D"
        let mockParam = ["stId": "10001", "routeId": "1001001", "ord": "1"]
        let answer1 = URL(string: "http://www.BBus.test?stId=10001&routeId=1001001&ord=1&serviceKey=uAtMsUVNMLIM%2FM9%3D%3D")
        let answer2 = URL(string: "http://www.BBus.test?routeId=1001001&stId=10001&ord=1&serviceKey=uAtMsUVNMLIM%2FM9%3D%3D")
        let answer3 = URL(string: "http://www.BBus.test?ord=1&routeId=1001001&stId=10001&serviceKey=uAtMsUVNMLIM%2FM9%3D%3D")
        let answer4 = URL(string: "http://www.BBus.test?stId=10001&ord=1&routeId=1001001&serviceKey=uAtMsUVNMLIM%2FM9%3D%3D")
        let answer5 = URL(string: "http://www.BBus.test?routeId=1001001&ord=1&stId=10001&serviceKey=uAtMsUVNMLIM%2FM9%3D%3D")
        let answer6 = URL(string: "http://www.BBus.test?ord=1&stId=10001&routeId=1001001&serviceKey=uAtMsUVNMLIM%2FM9%3D%3D")
        let answers = [answer1, answer2, answer3, answer4, answer5, answer6]
        
        // when
        guard let requestResult = self.requestFactory?.request(url: mockUrl, accessKey: mockAccessKey, params: mockParam) else {
            XCTFail("request result is nil")
            return
        }
        
        // then
        XCTAssertNotNil(requestResult)
        XCTAssertTrue(answers.contains(requestResult.url))
    }
}
