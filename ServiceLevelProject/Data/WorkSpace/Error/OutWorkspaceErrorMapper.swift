//
//  OutWorkspaceErrorMapper.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/02.
//

import Foundation

struct OutWorkspaceErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case missingData = "E13"
        case rejectOut = "E15"
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError(rawValue: identifier)
    }
}

