//
//  LoginType.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/15.
//

import Foundation

enum LoginType {
    case apple(idToken: String, nickName: String)
    case kakao
    case email(email: String, password: String)
    case none
}

extension LoginType: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: String) {
        if rawValue == "apple" {
            self = .apple(idToken: "", nickName: "")
        } else if rawValue == "kakao" {
            self = .kakao
        } else if rawValue == "email" {
            self = .email(email: "", password: "")
        } else {
            self = .none
        }
    }
    
    var rawValue: String {
        switch self {
        case .apple:
            return "apple"
        case .kakao:
            return "kakao"
        case .email(_, _):
            return "email"
        case .none:
            return "none"
        }
    }
}
