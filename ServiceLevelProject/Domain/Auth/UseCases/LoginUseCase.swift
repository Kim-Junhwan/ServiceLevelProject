//
//  SocialLoginUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/06.
//

import Foundation

enum LoginPlatform {
    case kakao
    case apple(idToken: String, nickName: String?)
    case email(email: String, password: String)
}

protocol LoginUseCase {
    func excute(_ platform: LoginType) async throws
}

final class DefaultLoginUseCase {
    let authRepository: AuthRepository
    let appState: AppState
    let deviceToken = ""
    
    init(authRepository: AuthRepository, appState: AppState) {
        self.authRepository = authRepository
        self.appState = appState
    }
}

extension DefaultLoginUseCase: LoginUseCase {
    func excute(_ platform: LoginType) async throws {
        let userProfile: UserProfile
        switch platform {
        case .apple(let idToken, let nickName):
            userProfile = try await authRepository.appleLogin(.init(idToken: idToken, nickName: nickName, deviceToken: deviceToken))
        case .kakao:
            let info = try await KakaoLoginManager().login()
            userProfile = try await authRepository.kakaoLogin(.init(oauthToken: info, deviceToken: deviceToken))
        case .email(let email, let password):
            userProfile = try await authRepository.emailLogin(.init(email: email, password: password, deviceToken: deviceToken))
        case .none:
            fatalError()
        }
        print(userProfile)
        appState.loginInfo.loginType = platform
        appState.userData.nickname = userProfile.nickName
        appState.userData.profileImagePath = userProfile.profileImage
        appState.token.accessToken = userProfile.accessToken
        appState.token.refreshToken = userProfile.refreshToken
        appState.isLoggedIn = true
        await appState.setLoginStatus(true)
    }
}
