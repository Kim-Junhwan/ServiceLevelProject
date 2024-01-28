//
//  RefreshTokenError.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/28.
//

import Foundation

struct RefreshTokenErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, Error {
        case availableToken = "E04"
        case refreshTokenTimeOut = "E06"
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError.init(rawValue: identifier)
    }
}
