//
//  ValidEmailError.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/13.
//

import Foundation

struct ValidEmailErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case alreadyUseEmail = "E12"
        case invalidRequest = "E11"
        
        var errorDescription: String? {
            switch self {
            case .alreadyUseEmail:
                "이미 사용중인 이메일입니다."
            case .invalidRequest:
                "잘못된 요청입니다. 다시 시도해주십시오"
            }
        }
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError(rawValue: identifier)
    }
}
