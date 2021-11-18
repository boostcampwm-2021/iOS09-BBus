//
//  Service.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

enum NetworkError: Error {
    case accessKeyError, urlError, unknownError, noDataError, noResponseError, responseError
}

// TODO: - Service Return Type 수정 필요
class Service {
    static let shared = Service()
    
    private let accessKeys: [String] = { () -> [String] in
        let keys = [Bundle.main.infoDictionary?["API_ACCESS_KEY1"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY2"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY3"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY4"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY5"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY6"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY7"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY8"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY9"] as? String]
        return keys.compactMap({ $0 })
    }()
    private lazy var order: Int = {
        self.accessKeys.count
    }()
    
    private init() { }

    func get(url: String, params: [String: String], on queue: DispatchQueue) -> AnyPublisher<Data, Error> {
        self.order = self.order > 0 ? self.order - 1 : self.accessKeys.count - 1
        if let request = self.makeRequest(url: url, params: params) {
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
        else {
            let publisher = PassthroughSubject<Data, Error>()
            queue.async {
                publisher.send(completion: .failure(NetworkError.urlError))
            }
            return publisher.eraseToAnyPublisher()
        }
    }
    
    private func makeRequest(url: String, params: [String: String]) -> URLRequest? {
        guard var components = URLComponents(string: url) else { return nil }
        var items: [URLQueryItem] = []
        params.forEach() { item in
            items.append(URLQueryItem(name: item.key, value: item.value))
        }
        components.queryItems = items
        if let query = components.percentEncodedQuery  {
            components.percentEncodedQuery = query + "&serviceKey=" + self.accessKeys[self.order]
        }
        else {
            return nil
        }
        if let url = components.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }
        else {
            return nil
        }
    }
}
