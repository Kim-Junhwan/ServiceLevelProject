//
//  SLPCommonError.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/11.
//

import Foundation

enum SLPCommonError: String, LocalizedError {
    case noAPIPermission = "E01"
    case unknownPath = "E97"
    case accessTokenTimeOut = "E05"
    case failAuthentication = "E02"
    case unknownUser = "E03"
    case tooMuchCall = "E98"
    
    var errorDescription: String? {
        return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
    }
}
