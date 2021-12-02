//
//  RequestFactory.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation

protocol Requestable {
    func request(url: String, accessKey: String, params: [String: String]) -> URLRequest?
}

struct RequestFactory: Requestable {
    func request(url: String, accessKey: String, params: [String: String]) -> URLRequest? {
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
