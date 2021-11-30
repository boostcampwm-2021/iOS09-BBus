//
//  NetworkService.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

enum NetworkError: Error {
    case accessKeyError, urlError, unknownError, noDataError, noResponseError, responseError
}

protocol NetworkServiceProtocol {
    func get(request: URLRequest, params: [String: String]) -> AnyPublisher<Data, Error>
}

struct NetworkService: NetworkServiceProtocol {
    func get(request: URLRequest, params: [String: String]) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError({ $0 as Error })
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.noResponseError
                }
                if response.statusCode != 200 {
                    throw NetworkError.responseError
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
