//
//  PostDMErrorMapper.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct PostDMErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case missingData = "E13"
        case invalidRequest = "E11"
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError(rawValue: identifier)
    }
    
}
