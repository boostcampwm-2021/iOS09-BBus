//
//  PublisherExtension.swift
//  BBus
//
//  Created by 이지수 on 2021/11/18.
//

import Foundation
import Combine

extension Publisher where Output == (Data, Int), Failure == Error {
    func mapBBusAPIError() -> AnyPublisher<Data, Error> {
        self.tryMap({ data, order -> Data in
            guard let code = BBusXMLParser().parse(dtoType: HeaderMessage.self, xml: data)?.header.headerCode,
                  let error = BBusAPIError(errorCode: code ) else { return data }
            Service.shared.removeAccessKey(at: order)
            throw error
        }).eraseToAnyPublisher()
    }

    func mapJsonBBusAPIError() -> AnyPublisher<Data, Error> {
        self.tryMap({ data, order -> Data in
            guard let json = try? JSONDecoder().decode(JsonHeader.self, from: data),
                  let statusCode = Int(json.msgHeader.headerCD),
                  let error = BBusAPIError(errorCode: statusCode) else { return data }
            Service.shared.removeAccessKey(at: order)
            throw error
        }).eraseToAnyPublisher()
    }
}

extension Publisher where Failure == Error {
    func retry(_ currentTokenExhaustedHandler: @escaping () -> Void, handler wholeTokenExhaustedHandler: @escaping (_ error: Error) -> Void) -> AnyPublisher<Self.Output, Never> {
        self.catch({ error -> AnyPublisher<Self.Output, Never> in
            switch error {
            case BBusAPIError.noMoreAccessKeyError, BBusAPIError.trafficExceed:
                wholeTokenExhaustedHandler(error)
            default:
                currentTokenExhaustedHandler()
            }
            
            let publisher = PassthroughSubject<Self.Output, Never>()
            DispatchQueue.global().async {
                publisher.send(completion: .finished)
            }
            return publisher.eraseToAnyPublisher()
        }).eraseToAnyPublisher()
    }
}

