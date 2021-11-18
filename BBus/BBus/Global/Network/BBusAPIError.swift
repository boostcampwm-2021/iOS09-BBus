//
//  BBusAPIError.swift
//  BBus
//
//  Created by 이지수 on 2021/11/18.
//

import Foundation

enum BBusAPIError: Error {
    case systemError, noneParamError, wrongParamError, noneResultError, noneAccessKeyError, noneRegisteredKeyError, suspendedKeyError, exceededKeyError, wrongRequestError, wrongRouteIdError, wrongStationError, noneBusArriveInfoError, wrongStartStationIdError, wrongEndStationIdError, preparingAPIError
    
    init?(errorCode: Int) {
        switch errorCode {
        case 1:
            self = Self.systemError
        case 2:
            self = Self.noneParamError
        case 3:
            self = Self.wrongParamError
        case 4:
            self = Self.noneResultError
        case 5:
            self = Self.noneAccessKeyError
        case 6:
            self = Self.noneRegisteredKeyError
        case 7:
            self = Self.suspendedKeyError
        case 8:
            self = Self.exceededKeyError
        case 20:
            self = Self.wrongRequestError
        case 21:
            self = Self.wrongRouteIdError
        case 22:
            self = Self.wrongStationError
        case 23:
            self = Self.noneBusArriveInfoError
        case 31:
            self = Self.wrongStartStationIdError
        case 32:
            self = Self.wrongEndStationIdError
        case 99:
            self = Self.preparingAPIError
        default :
            return nil
        }
    }
}
