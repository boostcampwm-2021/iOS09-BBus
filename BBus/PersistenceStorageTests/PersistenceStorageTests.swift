//
//  PersistenceStorageTests.swift
//  PersistenceStorageTests
//
//  Created by 김태훈 on 2021/11/30.
//

import XCTest
import Combine

class PersistenceStorageTests: XCTestCase {

    private let key: String = "PersistenceStorageTestKey"
    private let key2: String = "PersistenceStorageTestKey2"
    private let key3: String = "PersistenceStorageTestKey3"
    private let key4: String = "PersistenceStorageTestKey4"
    private let fileName: String = "BusRouteList"
    private let fileType: String = "json"
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        self.cancellables = []
    }

    struct DummyCodable: Codable, Equatable {
        let dummy: String
    }

    func test_create_성공() {

        //given
        UserDefaults.standard.removeObject(forKey: self.key)
        let storage = PersistenceStorage()
        let param = DummyCodable(dummy: "dummy")
        let expectation = self.expectation(description: "create가 에러 없이 정상 작동해야함")
        var resultOpt: Data?

        //when
        storage.create(key: self.key, param: param)
            .catchError { error in
                XCTFail()
            }
            .sink { data in
                resultOpt = data
                expectation.fulfill()
            }
            .store(in: &self.cancellables)

        //then
        waitForExpectations(timeout: 2)
        guard let result = resultOpt else { XCTFail(); return }
        let decodedResultOpt = try? PropertyListDecoder().decode(DummyCodable.self, from: result)
        guard let decodedResult = decodedResultOpt else { XCTFail(); return }
        XCTAssertEqual(decodedResult, param, "생성하려는 객체가 정상적으로 리턴되지 않았습니다.")
    }

    func test_getFromUserDefault_성공() {

        //given
        UserDefaults.standard.removeObject(forKey: self.key2)

        let storage = PersistenceStorage()
        let param = DummyCodable(dummy: "dummy")
        let createExpect = self.expectation(description: "목 데이터 생성이 선행되어야 함")
        let expectation = self.expectation(description: "getFromUserDefault가 에러 없이 정상 작동해야함")
        var resultOpt: Data?

        storage.create(key: self.key2, param: param)
            .catchError { error in
                XCTFail()
            }
            .sink { _ in
                createExpect.fulfill()
            }
            .store(in: &self.cancellables)

        wait(for: [createExpect], timeout: 5)
        //when
        storage.getFromUserDefaults(key: self.key2)
            .catchError { error in
                XCTFail()
            }
            .sink { data in
                resultOpt = data
                expectation.fulfill()
            }
            .store(in: &self.cancellables)

        //then
        wait(for: [expectation], timeout: 5)
        guard let result = resultOpt else { XCTFail(); return }
        let decodedResultOpt = try? PropertyListDecoder().decode([DummyCodable].self, from: result)
        guard let decodedResult = decodedResultOpt else { XCTFail(); return }
        XCTAssertEqual(decodedResult, [param], "저장된 객체를 불러오지 못했습니다.")
    }

    func test_getFromUserDefault_실패() {

        //given
        UserDefaults.standard.removeObject(forKey: self.key3)
        let storage = PersistenceStorage()
        let expectation = self.expectation(description: "데이터가 없기 때문에, getFromUserDefault가 작동하지않음")
        var resultOpt: Data?

        //when
        storage.getFromUserDefaults(key: self.key3)
            .catchError { error in
                XCTFail()
            }
            .sink { data in
                resultOpt = data
                expectation.fulfill()
            }
            .store(in: &self.cancellables)

        let emptyArrayDataOpt = try? PropertyListEncoder().encode([FavoriteItemDTO]())

        //then
        waitForExpectations(timeout: 5)
        guard let result = resultOpt,
              let emptyArrayData = emptyArrayDataOpt else { XCTFail(); return }
        XCTAssertEqual(result, emptyArrayData, "저장된 데이터가 존재하면 안됩니다.")
    }

    func test_실제저장소_get_BusRouteList_수신성공() {

        //given
        let storage = PersistenceStorage()
        let expectation = self.expectation(description: "PersistenceStorageRealGet")

        //when
        storage.get(file: self.fileName, type: self.fileType)
            .catchError { error in
                XCTFail()
            }
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &self.cancellables)

        //then
        waitForExpectations(timeout: 2)
    }

    func test_실제저장소_get_BusRouteList_수신실패() {

        //given
        let storage = PersistenceStorage()
        let expectation = self.expectation(description: "PersistenceStorageRealGet2")

        //when
        storage.get(file: "아무파일이름입니다.", type: self.fileType)
            .catchError { error in
                expectation.fulfill()
            }
            .sink { data in
                XCTFail()
            }
            .store(in: &self.cancellables)

        //then
        waitForExpectations(timeout: 2)
    }


    func test_실제저장소_delete_성공() {
        //given
        UserDefaults.standard.removeObject(forKey: self.key4)
        let storage = PersistenceStorage()
        let expectation = self.expectation(description: "데이터를 delete 성공해야함")
        var resultOpt: Data?
        var params = [DummyCodable(dummy: "dummy1"), DummyCodable(dummy: "dummy2"), DummyCodable(dummy: "dummy3"), DummyCodable(dummy: "dummy4")]

        for param in params {
            let createExpect = self.expectation(description: "delete를 위한 목 데이터 생성이 완료되어야함")
            storage.create(key: self.key4, param: param)
                .catchError { error in
                    XCTFail()
                }
                .sink { _ in
                    // 동시접근 이슈
                    createExpect.fulfill()
                }
                .store(in: &self.cancellables)
            wait(for: [createExpect], timeout: 5)
        }

        //when
        storage.delete(key: self.key4, param: params[2])
            .catchError { error in
                XCTFail()
            }
            .sink { data in
                resultOpt = data
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        params.remove(at: 2) // 배열에서도 제거, 비교하기 위함임

        //then
        wait(for: [expectation], timeout: 5)
        guard let result = resultOpt else { XCTFail(); return }
        let decodedResultOpt = try? PropertyListDecoder().decode([DummyCodable].self, from: result)
        guard let decodedResult = decodedResultOpt else { XCTFail(); return }
        XCTAssertEqual(params, decodedResult, "제거된 데이터와 상이합니다.")
    }
}
