//
//  UserLoginStatusManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/16.
//

import Foundation

class BaseState {}

final class AppState: BaseState, ObservableObject {
    @MainActor @Published var isLoggedIn: Bool = false
    var loginInfo: LoginInfo = .init()
    var userData: UserData = .init(nickname: "")
    var token: Token = .init()
    
    @MainActor func setLoginStatus(_ bool: Bool) {
        self.isLoggedIn = bool
    }
    
    func setLoginInfo(userProfile: UserProfile) {
        token.accessToken = userProfile.accessToken
        token.refreshToken = userProfile.refreshToken
        userData.nickname = userProfile.nickName
        userData.profileImagePath = userProfile.profileImage
    }
}

struct UserData {
    var nickname: String
    var profileImagePath: String?
}

struct LoginInfo {
    @UserDefault(key: "loginKey", defaultValue: nil)
    private var loginTypeValue: String?
    private var kakaoLoginInfo = KakaoLoginInfo()
    private var emailLoginInfo = EmailLoginInfo()
    private var appleLoginInfo = AppleLoginInfo()
    
    
    var loginType: LoginPlatform {
        get {
            guard let value = loginTypeValue, let loginType = LoginPlatform(rawValue: value) else { return .none }
            switch loginType {
            case .kakao(_):
                guard let token = kakaoLoginInfo.oauthToken else { return .none }
                return .kakao(oauthToken: token)
            case .apple(_):
                guard let token = appleLoginInfo.idToken else { return .none }
                return .apple(idToken: token)
            case .email(_, _):
                guard let email = emailLoginInfo.email, let password = emailLoginInfo.password else { return .none }
                return .email(email: email, password: password)
            case .none:
                return .none
            }
        }
        
        set {
            switch newValue {
            case .kakao(let oauthToken):
                kakaoLoginInfo.oauthToken = oauthToken
            case .apple(let idToken):
                appleLoginInfo.idToken = idToken
            case .email(let email, let password):
                emailLoginInfo.email = email
                emailLoginInfo.password = password
            case .none:
                break
            }
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