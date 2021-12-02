//
//  NetworkServiceTests.swift
//  NetworkServiceTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest
import Combine

class NetworkServiceTests: XCTestCase {
    
    private let timeout: TimeInterval = 10
    private var successRequest: URLRequest?
    private var redirectFailRequest: URLRequest?
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        guard let successRequest = self.makeSuccessRequest(),
              let redirectFailRequest = self.makeRedirectRequest() else { throw NetworkError.urlError }
        self.successRequest = successRequest
        self.redirectFailRequest = redirectFailRequest
    }
    
    private func makeSuccessRequest() -> URLRequest? {
        guard let key = Bundle.main.infoDictionary?["API_ACCESS_KEY1"] as? String,
              let url = URL(string: "http://ws.bus.go.kr/api/rest/arrive/getLowArrInfoByStId?stId=100&resultType=json&serviceKey=\(key)")
        else { return nil }
        return URLRequest(url: url)
    }
    
    private func makeRedirectRequest() -> URLRequest? {
        guard let url = URL(string: "http://www.naver.com/.png") else { return nil }
        return URLRequest(url: url)
    }
    
    func test_get_요청_성공() throws {
        // given
        let expectation = self.expectation(description: "get 요청이 성공되어야 한다.")
        guard let successRequest = self.successRequest else { return }
        let networkService = NetworkService()
        var data: Data? = nil
        
        // when
        networkService.get(request: successRequest)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { result in
                data = result
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: self.timeout)
        
        // then
        XCTAssertNotNil(data)
    }

    func test_get_리다이렉트로_요청_실패() throws {
        // given
        let expectation = self.expectation(description: "get 요청이 실패되어야 한다.")
        guard let redirectFailRequest = self.redirectFailRequest else { return }
        let networkService = NetworkService()
        var error: Error? = nil
        
        // when
        networkService.get(request: redirectFailRequest)
            .sink(receiveCompletion: { result in
                if case .failure(let resultError) = result {
                    error = resultError
                }
                expectation.fulfill()
            }, receiveValue: { data in
                return
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: self.timeout)
        
        // then
        XCTAssertNotNil(error)
    }
}
