//
//  LoginInfo.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/25.
//

import Foundation

enum LoginPlatform {
    case kakao(oauthToken: String)
    case apple(idToken: String)
    case email(email: String, password: String)
    case none
}

extension LoginPlatform: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: String) {
        if rawValue == "apple" {
            self = .apple(idToken: "")
        } else if rawValue == "kakao" {
            self = .kakao(oauthToken: "")
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


struct EmailLoginInfo {
    @UserDefault(key: "email", defaultValue: nil)
    var email: String?
    var password: String? {
        get {
            try? KeychainManager.shared.readTokenAtKeyChain(key: "password")
        }
        
        set {
            guard let newValue else { return  }
            try? KeychainManager.shared.saveTokenAtKeyChain(key: "password", value: newValue)
        }
    }
}

struct AppleLoginInfo {
    var idToken: String? {
        get {
            try? KeychainManager.shared.readTokenAtKeyChain(key: "appleIDToken")
        }
        
        set {
            guard let newValue else { return  }
            try? KeychainManager.shared.saveTokenAtKeyChain(key: "appleIDToken", value: newValue)
        }
    }
}

struct KakaoLoginInfo {
    var oauthToken: String? {
        get {
            try? KeychainManager.shared.readTokenAtKeyChain(key: "kakaoOauthToken")
        }
        
        set {
            guard let newValue else { return  }
            try? KeychainManager.shared.saveTokenAtKeyChain(key: "kakaoOauthToken", value: newValue)
        }
    }
}
