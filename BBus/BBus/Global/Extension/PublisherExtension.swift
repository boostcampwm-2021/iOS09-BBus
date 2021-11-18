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
            guard let code = BBusXMLParser().parse(dtoType: MessageHeader.self, xml: data)?.header.headerCode,
                  let error = BBusAPIError(errorCode: code ) else { return data }
            Service.removeAccessKey(at: order)
            throw error
        }).eraseToAnyPublisher()
    }
}

extension Publisher where Failure == Error {
    func retry(_ retry: @escaping () -> Void, handler: @escaping (_ error: Error) -> Void) -> AnyPublisher<Self.Output, Never> {
        self.catch({ error -> AnyPublisher<Self.Output, Never> in
            switch error {
            case BBusAPIError.noMoreAccessKeyError, BBusAPIError.trafficExceed:
                handler(error)
            default:
                retry()
            }
            
            let publisher = PassthroughSubject<Self.Output, Never>()
            DispatchQueue.global().async {
                publisher.send(completion: .finished)
            }
            return publisher.eraseToAnyPublisher()
        }).eraseToAnyPublisher()
    }
}

