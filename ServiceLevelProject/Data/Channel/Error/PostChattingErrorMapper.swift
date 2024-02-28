//
//  PostChattingErrorMapper.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

struct PostChattingErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case missingData = "E13"
        case invalidRequest = "E11"
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError(rawValue: identifier)
    }
}
