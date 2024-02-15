//
//  MissingDataError.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//

import Foundation

struct MissingDataErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case missingData = "E13"
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError(rawValue: identifier)
    }
}
