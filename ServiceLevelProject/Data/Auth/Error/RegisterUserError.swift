//
//  RegisterUserError.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/14.
//

import Foundation

struct RegisterUserErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case alreadyRegistUser = "E12"
        case invalidRequest = "E11"
        
        var errorDescription: String? {
            switch self {
            case .alreadyRegistUser:
                return "이미 가입된 회원입니다. 로그인을 진행해주세요."
            case .invalidRequest:
                return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
            }
        }
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError.init(rawValue: identifier)
    }
}
