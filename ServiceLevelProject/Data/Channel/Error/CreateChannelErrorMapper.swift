//
//  CreateChannelErrorMapper.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/24.
//

import Foundation

struct CreateChannelErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case overlapChannel = "E12"
        case missingData = "E13"
        case invalidRequest = "E11"
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError(rawValue: identifier)
    }
    
}
