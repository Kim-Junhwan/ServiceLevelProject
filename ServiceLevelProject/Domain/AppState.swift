//
//  UserLoginStatusManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/16.
//

import Foundation

class BaseState {}

@MainActor
final class AppState: BaseState, ObservableObject {
    @Published var isLoggedIn: Bool = false
    var loginInfo: LoginInfo = .init()
    var userData: UserData = .init(nickname: "")
    var token: Token = .init()
    
    func setLoginStatus(_ bool: Bool) {
        isLoggedIn = bool
    }
}

struct UserData {
    var nickname: String
    var profileImagePath: String?
}

struct LoginInfo {
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
}

struct Token {
    var accessToken: String? {
        get {
            try? KeychainManager.shared.readTokenAtKeyChain(key: "accessToken")
        }
        set {
            try? KeychainManager.shared.saveTokenAtKeyChain(key: "accessToken", value: newValue ?? "")
        }
    }
    
    var refreshToken: String? {
        get {
            try? KeychainManager.shared.readTokenAtKeyChain(key: "refreshToken")
        }
        set {
            try? KeychainManager.shared.saveTokenAtKeyChain(key: "refreshToken", value: newValue ?? "")
        }
    }
}
