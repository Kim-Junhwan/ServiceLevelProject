//
//  UserLoginStatusManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/16.
//

import Foundation

final class AppState: ObservableObject {
    @MainActor @Published var isLoggedIn: Bool = false
    @MainActor @Published var workspaceList: WorkspaceList = .init(list: [])
    @Published var userData: UserData = .init()
    var loginInfo: LoginInfo = .init()
    var deviceToken: String {
        get {
            return ""
        }
    }
    
    func setLoginInfo(userProfile: UserProfile) {
        setToken(accessToken: userProfile.accessToken, refreshToken: userProfile.refreshToken)
        userData.nickname = userProfile.nickName
        userData.id = userProfile.userId
        userData.profileImagePath = userProfile.profileImage
    }
    
    func setToken(accessToken: String, refreshToken: String?) {
        Token.accessToken = accessToken
        Token.refreshToken = refreshToken
    }
}

struct UserData {
    var nickname: String = ""
    var profileImagePath: String?
    var id: Int = 0
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
            loginTypeValue = newValue.rawValue
        }
    }
}

struct Token {
    static var accessToken: String? {
        get {
            try? KeychainManager.shared.readTokenAtKeyChain(key: "accessToken")
        }
        set {
            try? KeychainManager.shared.saveTokenAtKeyChain(key: "accessToken", value: newValue ?? "")
        }
    }
    
    static var refreshToken: String? {
        get {
            try? KeychainManager.shared.readTokenAtKeyChain(key: "refreshToken")
        }
        set {
            try? KeychainManager.shared.saveTokenAtKeyChain(key: "refreshToken", value: newValue ?? "")
        }
    }
}


