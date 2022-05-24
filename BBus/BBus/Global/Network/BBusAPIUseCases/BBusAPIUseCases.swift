//
//  BBusAPIUsecases.swift
//  BBus
//
//  Created by Kang Minsang on 2021/11/10.
//

import Foundation
import Combine

struct BBusAPIUseCases {
    let tokenManageType: TokenManagable.Type
    
    let networkService: NetworkServiceProtocol
    let persistenceStorage: PersistenceStorageProtocol
    let requestFactory: Requestable.Type
    
    init(networkService: NetworkServiceProtocol, persistenceStorage: PersistenceStorageProtocol, tokenManageType: TokenManagable.Type, requestFactory: Requestable.Type) {
        self.networkService = networkService
        self.persistenceStorage = persistenceStorage
        self.tokenManageType = tokenManageType
        self.requestFactory = requestFactory
    }
}
