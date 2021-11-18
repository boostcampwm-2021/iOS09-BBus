//
//  PublisherExtension.swift
//  BBus
//
//  Created by 이지수 on 2021/11/18.
//

import Foundation
import Combine

extension Publisher where Output == Data, Failure == Error {
    func mapBBusAPIError() -> AnyPublisher<Data, Error> {
        self.tryMap({ data -> Data in
            guard let code = BBusXMLParser().parse(dtoType: MessageHeader.self, xml: data)?.header.headerCode,
                  let error = BBusAPIError(errorCode: code ) else { return data }
            throw error
        })
            .eraseToAnyPublisher()
    }
}
