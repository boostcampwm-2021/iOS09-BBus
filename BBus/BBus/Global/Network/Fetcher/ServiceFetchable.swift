//
//  ServiceFetcher.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation
import Combine

protocol ServiceFetchable {
    var tokenManager: TokenManagable { get }
    var requestFactory: Requestable { get }
    
    func errorPublisher(with error: Error) -> AnyPublisher<Data, Error>
    
    func fetch(url: String, param: [String: String]) -> AnyPublisher<Data, Error>
}

extension ServiceFetchable {
    func errorPublisher(with error: Error) -> AnyPublisher<Data, Error> {
        let publisher = CurrentValueSubject<Data?, Error>(nil)
        publisher.send(completion: .failure(error))
        return publisher.compactMap({$0})
            .eraseToAnyPublisher()
    }
    
    func fetch(url: String, param: [String: String]) -> AnyPublisher<Data, Error> {
        guard let key = try? self.tokenManager.randomAccessKey() else { return self.errorPublisher(with: BBusAPIError.noMoreAccessKeyError) }
        guard let request =
                self.requestFactory.request(url: url, accessKey: key.key, params: param) else { return self.errorPublisher(with: NetworkError.urlError) }
        
        return NetworkService.shared.get(request: request, params: param)
            .mapJsonBBusAPIError {
                tokenManager.removeAccessKey(at: key.index)
            }
    }
}
