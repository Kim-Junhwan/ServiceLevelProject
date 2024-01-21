//
//  LoginError.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/21.
//

import Foundation

struct LoginErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case loginFail = "E03"
        
        var errorDescription: String? {
            switch self {
            case .loginFail:
                return "이메일 또는 비밀번호가 올바르지 않습니다."
            }
        }
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError.init(rawValue: identifier)
    }
}
