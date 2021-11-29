//
//  BBusAPIUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

struct BBusAPIUseCases {
    let networkService: NetworkServiceProtocol
    let persistenceStorage: PersistenceStorageProtocol
    let requestFactory: Requestable
    
    init(networkService: NetworkServiceProtocol, persistenceStorage: PersistenceStorageProtocol, requestFactory: Requestable) {
        self.networkService = networkService
        self.persistenceStorage = persistenceStorage
        self.requestFactory = requestFactory
    }
}
