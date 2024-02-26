//
//  InviteMemberError.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Foundation

struct InviteMemberError: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case missingData = "E13"
        case missinUser = "E03"
        case notAdmin = "E14"
        case invalidRequest = "E11"
        case alreadyComeInMember = "E12"
        
        var errorDescription: String? {
            switch self {
            case .missinUser:
                return "회원정보를 찾을 수 없습니다."
            case .alreadyComeInMember:
                return "이미 워크스페이스에 소속된 팀원이에요."
            default:
                return nil
            }
        }
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError(rawValue: identifier)
    }
}
