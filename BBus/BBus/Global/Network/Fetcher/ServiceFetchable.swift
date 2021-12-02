//
//  ServiceFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol ServiceFetchable {
    var networkService: NetworkServiceProtocol { get }
    var tokenManager: TokenManagable { get }
    var requestFactory: Requestable { get }

    func fetch(url: String, param: [String: String]) -> AnyPublisher<Data, Error>
}

extension ServiceFetchable {
    func fetch(url: String, param: [String: String]) -> AnyPublisher<Data, Error> {
        guard let key = try? self.tokenManager.randomAccessKey() else { return BBusAPIError.noMoreAccessKeyError.publisher }
        guard let request =
                self.requestFactory.request(url: url, accessKey: key.key, params: param) else { return NetworkError.urlError.publisher }
        return networkService.get(request: request, params: param)
            .mapJsonBBusAPIError {
                self.tokenManager.removeAccessKey(at: key.index)
            }
    }
}

fileprivate extension Error {
    var publisher: AnyPublisher<Data, Error> {
        let publisher = CurrentValueSubject<Data?, Error>(nil)
        publisher.send(completion: .failure(self))
        return publisher.compactMap({$0})
            .eraseToAnyPublisher()
    }
}
