//
//  PublisherExtension.swift
//  BBus
//
//  Created by 이지수 on 2021/11/18.
//

import Foundation
import Combine

extension Publisher where Output == Data, Failure == Error {
    func mapJsonBBusAPIError(with removeAccessKeyHandler: @escaping () -> Void ) -> AnyPublisher<Data, Error> {
        self.tryMap({ data -> Data in
            guard let json = try? JSONDecoder().decode(JsonHeader.self, from: data),
                  let statusCode = Int(json.msgHeader.headerCD),
                  let error = BBusAPIError(errorCode: statusCode) else { return data }
            switch error {
            case .noneAccessKeyError, .noneRegisteredKeyError, .suspendedKeyError, .exceededKeyError:
                removeAccessKeyHandler()
            default:
                break
            }
            throw error
        }).eraseToAnyPublisher()
    }
}

extension Publisher where Failure == Error {
    func catchError(_ handler: @escaping (Error) -> Void) -> AnyPublisher<Self.Output, Never> {
        self.catch({ error -> AnyPublisher<Self.Output, Never> in
            handler(error)
            let publisher = PassthroughSubject<Self.Output, Never>()
            DispatchQueue.global().async {
                publisher.send(completion: .finished)
            }
            return publisher.eraseToAnyPublisher()
        }).eraseToAnyPublisher()
    }
}
