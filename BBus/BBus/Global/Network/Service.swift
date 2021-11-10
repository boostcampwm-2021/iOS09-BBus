//
//  Service.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

enum NetworkError: Error {
    case accessKeyError, urlError
}


// TODO: - Service Return Type 수정 필요
class Service {
    static let shared = Service()
    
    private let accessKey = (Bundle.main.infoDictionary?["API_ACCESS_KEY"] as? String)?.removingPercentEncoding
    
    private init() { }
    
    func get(url: String, params: [String: String]) -> Result<URLSession.DataTaskPublisher, NetworkError> {
        guard let accessKey = self.accessKey else { return .failure(NetworkError.accessKeyError) }
        guard var components = URLComponents(string: url) else { return .failure(NetworkError.urlError) }
        
        var items: [URLQueryItem] = [URLQueryItem(name: "serviceKey", value: accessKey)]
        params.forEach() { item in
            items.append(URLQueryItem(name: item.key, value: item.value))
        }
        components.queryItems = items
        
        if let url = components.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return .success(URLSession.init(configuration: .default).dataTaskPublisher(for: request))
        } else {
            return .failure(NetworkError.urlError)
        }
    }
}
