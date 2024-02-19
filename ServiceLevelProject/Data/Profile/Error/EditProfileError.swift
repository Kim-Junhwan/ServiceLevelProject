//
//  EditProfileError.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/19.
//

import Foundation

struct EditProfileErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case invalidRequest = "E11"
        
        var errorDescription: String? {
            switch self {
            case .invalidRequest:
                "잘못된 요청입니다. 다시 시도해주십시오"
            }
        }
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError(rawValue: identifier)
    }
}
