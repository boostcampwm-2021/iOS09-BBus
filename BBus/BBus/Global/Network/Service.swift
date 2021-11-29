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
final class Service {
    static let shared = Service()
    
    private var accessKeys: [String] = { () -> [String] in
        let keys = [Bundle.main.infoDictionary?["API_ACCESS_KEY1"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY2"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY3"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY4"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY5"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY6"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY7"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY8"] as? String, Bundle.main.infoDictionary?["API_ACCESS_KEY9"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY10"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY11"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY12"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY13"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY14"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY15"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY16"] as? String,
            Bundle.main.infoDictionary?["API_ACCESS_KEY17"] as? String]
        return keys.compactMap({ $0 })
    }()
    
    private var keys: [Int] = []
    
    private init() {
        self.keys = Array(0..<self.accessKeys.count)
    }
    
    func removeAccessKey(at order: Int) {
        self.keys = self.keys.filter({ $0 != order })
    }

    func get(url: String, params: [String: String]) -> AnyPublisher<(Data, Int)?, Error> {
        guard self.keys.count != 0,
              let order = self.keys.randomElement() else {
                  let publisher = CurrentValueSubject<(Data, Int)?, Error>(nil)
                  publisher.send(completion: .failure(BBusAPIError.noMoreAccessKeyError))
                  return publisher.eraseToAnyPublisher()
        }
        if let request = self.makeRequest(url: url, accessKey: self.accessKeys[order], params: params) {
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
            let publisher = CurrentValueSubject<(Data, Int)?, Error>(nil)
            publisher.send(completion: .failure(NetworkError.urlError))
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
        guard let query = components.percentEncodedQuery else { return nil }
        components.percentEncodedQuery = query + "&serviceKey=" + accessKey
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
