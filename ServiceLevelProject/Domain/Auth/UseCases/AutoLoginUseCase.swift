//
//  AutoLoginUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/25.
//

import Foundation

protocol AutoLoginUseCase {
    func excute(_ platform: LoginPlatform) async throws
}

class DefaultAutoLoginUseCase {
    let authRepository: AuthRepository
    let appState: AppState
    
    init(authRepository: AuthRepository, appState: AppState) {
        self.authRepository = authRepository
        self.appState = appState
    }
}

extension DefaultAutoLoginUseCase: AutoLoginUseCase {
    func excute(_ platform: LoginPlatform) async throws {
        let userProfile: UserProfile
        switch platform {
        case .kakao(let oauthToken):
            userProfile = try await authRepository.kakaoLogin(.init(oauthToken: oauthToken, deviceToken: nil))
        case .apple(let idToken):
            userProfile = try await authRepository.appleLogin(.init(idToken: idToken, nickName: nil, deviceToken: nil))
        case .email(let email, let password):
            userProfile = try await authRepository.emailLogin(.init(email: email, password: password, deviceToken: nil))
        case .none:
            return
        }
        appState.setLoginInfo(userProfile: userProfile)
        await appState.setLoginStatus(true)
    }
}
