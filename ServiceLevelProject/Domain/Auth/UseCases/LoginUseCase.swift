//
//  SocialLoginUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/06.
//

import Foundation

protocol LoginUseCase {
    func excute(_ platform: LoginType) async throws
}

final class DefaultLoginUseCase {
    let authRepository: AuthRepository
    let appState: AppState
    var deviceToken: String?
    
    init(authRepository: AuthRepository, appState: AppState) {
        self.authRepository = authRepository
        self.appState = appState
    }
}

extension DefaultLoginUseCase: LoginUseCase {
    func excute(_ platform: LoginType) async throws {
        let userProfile: UserProfile
        let loginPlatform: LoginPlatform
        switch platform {
        case .apple(let idToken, let nickName):
            userProfile = try await authRepository.appleLogin(.init(idToken: idToken, nickName: nickName, deviceToken: deviceToken))
            loginPlatform = .apple(idToken: idToken)
        case .kakao:
            let info = try await KakaoLoginManager().login()
            userProfile = try await authRepository.kakaoLogin(.init(oauthToken: info, deviceToken: deviceToken))
            loginPlatform = .kakao(oauthToken: info)
        case .email(let email, let password):
            userProfile = try await authRepository.emailLogin(.init(email: email, password: password, deviceToken: deviceToken))
            loginPlatform = .email(email: email, password: password)
        case .none:
            fatalError()
        }
        appState.setLoginInfo(userProfile: userProfile)
        appState.loginInfo.loginType = loginPlatform
        await appState.setLoginStatus(true)
    }
}
