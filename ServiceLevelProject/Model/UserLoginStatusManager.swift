//
//  UserLoginStatusManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/16.
//

import Foundation

final class UserLoginStatusManager: LoginInfoRepository, ObservableObject {
    
    @UserDefault(key: "loginKey", defaultValue: nil)
    private var loginTypeValue: String?
    @UserDefault(key: "email", defaultValue: nil)
    private var email: String?
    private var password: String? {
        get {
            try? KeychainManager.shared.readTokenAtKeyChain(key: "password")
        }
        
        set {
            guard let passwordValue = newValue else { return  }
            try? KeychainManager.shared.saveTokenAtKeyChain(key: "password", value: passwordValue)
        }
    }
    
    //현재 어떤 방식으로 로그인 했는지에 대한 상태값
    var loginType: LoginType {
        get {
            guard let value = loginTypeValue, let loginType = LoginType(rawValue: value) else { return .none }
            if case .email(_, _) = loginType {
                guard let email, let password  else { return .none }
                return .email(email: email, password: password)
            }
            return loginType
        }
        set {
            if case .email(let email, let password) = loginType {
                self.email = email
                self.password = password
            }
            loginTypeValue = newValue.rawValue
        }
    }
    
    @Published var isLoggedIn: Bool = false
    
    func saveToken(accessToken: String, refreshToken: String?) throws {
        try KeychainManager.shared.saveTokenAtKeyChain(key: Token.accessToken.rawValue, value: accessToken)
        if let refreshToken {
            try KeychainManager.shared.saveTokenAtKeyChain(key: Token.refreshToken.rawValue, value: refreshToken)
        }
    }
    
    func logout() {
        loginType = .none
        isLoggedIn = false
    }
}
