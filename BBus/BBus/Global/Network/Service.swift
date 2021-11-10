//
//  Service.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

enum APIType {
    case busArrive, routeInfo, stationInfo, busLocation
    
    func toString() -> String? {
        switch self {
        case .busArrive :
            return Bundle.main.infoDictionary?["BUS_ARRIVE_API_ACCESS_KEY"] as? String
        case .busLocation :
            return Bundle.main.infoDictionary?["BUS_ARRIVE_API_ACCESS_KEY"] as? String
        case .routeInfo :
            return Bundle.main.infoDictionary?["BUS_ARRIVE_API_ACCESS_KEY"] as? String
        case .stationInfo :
            return Bundle.main.infoDictionary?["BUS_ARRIVE_API_ACCESS_KEY"] as? String
        }
    }
}

enum NetworkError: Error {
    case accessKeyError, urlError
}


// TODO: - Service Return Type 수정 필요
class Service {
    static let shared = Service()
    
    private init() { }
    
    func get(url: String, api: APIType, params: [String: String]) -> Result<URLSession.DataTaskPublisher, NetworkError> {
        guard let accessKey = api.toString() else { return .failure(NetworkError.accessKeyError) }
        guard var components = URLComponents(string: url + "?serviceKey" + accessKey) else { return .failure(NetworkError.urlError) }
        
        var items: [URLQueryItem] = []
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
