//
//  UserLoginStatusManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/16.
//

import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var workspaceList: [WorkSpaceThumbnail] = []
    @Published var userData: UserData = .init()
    @Published var selectWorkspace: WorkspaceDetailInfo?
    var loginInfo: LoginInfo = .init()
    
    @UserDefault(key: "currentWorkspaceId", defaultValue: nil)
    private var currentWorkspaceId: Int?
    
    var currentWorkspace: WorkSpaceThumbnail? {
        return workspaceList.first {$0.id == currentWorkspaceId}
    }
    
    var deviceToken: String {
        get {
            return ""
        }
    }
    
    func selectWorkspace(workspaceId: Int, detailWorkspaceInfo: WorkspaceDetailInfo) {
        let selectedWorkspace = workspaceList.first { $0.id == workspaceId }
        selectWorkspace = detailWorkspaceInfo
        currentWorkspaceId = workspaceId
    }
    
    func setUserData(_ userData: UserProfile) {
        let newUserData = UserData(nickname: userData.nickname, profileImagePath: userData.profileImage, id: userData.userId, email: userData.email, phone: userData.phone, sesacCoin: userData.sesacCoin ?? self.userData.sesacCoin, createdAt: userData.createdAt)
        self.userData = newUserData
    }
    
     func setLoginInfo(userProfile: RegistUserProfile) {
        setToken(accessToken: userProfile.accessToken, refreshToken: userProfile.refreshToken)
        userData.nickname = userProfile.nickName
        userData.id = userProfile.userId
        userData.profileImagePath = userProfile.profileImage
        userData.phone = userProfile.phone
        userData.email = userProfile.email
    }
    
    func setToken(accessToken: String, refreshToken: String?) {
        Token.accessToken = accessToken
        Token.refreshToken = refreshToken
    }
    
    func logout() {
        isLoggedIn = false
        loginInfo.loginType = .none
        Token.accessToken = nil
        Token.refreshToken = nil
    }
}

struct UserData {
    var nickname: String = ""
    var profileImagePath: String?
    var id: Int = 0
    var email: String = ""
    var phone: String?
    var sesacCoin: Int = 0
    var createdAt: Date = Date()
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


