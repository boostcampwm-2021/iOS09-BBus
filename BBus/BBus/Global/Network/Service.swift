//
//  Service.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

enum NetworkError: Error {
    case accessKeyError, urlError, unknownError, noDataError, noResponseError, responseError, trafficExceed
}

// TODO: - Service Return Type 수정 필요
class Service {
    static let shared = Service()
    
    private static var accessKeys: [String] = { () -> [String] in
        let keys = [Bundle.main.infoDictionary?["API_ACCESS_KEY1"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY2"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY3"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY4"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY5"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY6"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY7"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY8"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY9"] as? String]
        return keys.compactMap({ $0 })
    }()
    
    private static var keys: [Int] = []
    
    private init() {
        Self.keys = Array(0..<Self.accessKeys.count)
    }
    
    static func removeAccessKey(at order: Int) {
        Self.keys = Self.keys.filter({ $0 != order })
    }

    func get(url: String, params: [String: String], on queue: DispatchQueue) -> AnyPublisher<(Data, Int), Error> {
        let userDefaultKey = "APIRequestCount"
        let apiRequestCount = UserDefaults.standard.object(forKey: userDefaultKey) as? Int ?? 0
        if apiRequestCount > 300 {
            queue.async { [weak publisher] in publisher?.send(completion: .failure(NetworkError.trafficExceed)) }
            return publisher.eraseToAnyPublisher()
        }
        UserDefaults.standard.set(apiRequestCount + 1, forKey: userDefaultKey)
        guard Self.keys.count != 0,
              let order = Self.keys.randomElement() else {
                  let publisher = PassthroughSubject<(Data, Int), Error>()
                  queue.async {
                      publisher.send(completion: .failure(BBusAPIError.noMoreAccessKeyError))
                  }
                  return publisher.eraseToAnyPublisher()
        }
        if let request = self.makeRequest(url: url, accessKey: Self.accessKeys[order], params: params) {
            return URLSession.shared.dataTaskPublisher(for: request)
                .mapError({ $0 as Error })
                .tryMap { data, response -> (Data, Int) in
                    guard let response = response as? HTTPURLResponse else {
                        throw NetworkError.noResponseError
                    }
                    if response.statusCode != 200 {
                        throw NetworkError.responseError
                    }
                    return (data, order)
                }
                .eraseToAnyPublisher()
        }
        else {
            let publisher = PassthroughSubject<(Data, Int), Error>()
            queue.async {
                publisher.send(completion: .failure(NetworkError.urlError))
            }
            return publisher.eraseToAnyPublisher()
        }
    }
    
    private func makeRequest(url: String, accessKey: String, params: [String: String]) -> URLRequest? {
        guard var components = URLComponents(string: url) else { return nil }
        var items: [URLQueryItem] = []
        params.forEach() { item in
            items.append(URLQueryItem(name: item.key, value: item.value))
        }
        components.queryItems = items
        if let query = components.percentEncodedQuery  {
            components.percentEncodedQuery = query + "&serviceKey=" + accessKey
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
