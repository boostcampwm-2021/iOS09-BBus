//
//  PersistencetFetchable.swift
//  BBus
//
//  Created by 이지수 on 2021/11/29.
//

import Foundation

protocol PersistenceFetchable {
    var persistenceStorage: PersistenceStorageProtocol { get }
}
