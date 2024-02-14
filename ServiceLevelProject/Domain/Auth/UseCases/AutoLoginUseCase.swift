//
//  AutoLoginUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/25.
//

import Foundation

protocol AutoLoginUseCase {
    func excute() async throws
}

class DefaultAutoLoginUseCase {
    let authRepository: AuthRepository
    let workspaceRepository: WorkspaceRepository
    let appState: AppState
    
    init(authRepository: AuthRepository, workspaceRepository: WorkspaceRepository, appState: AppState) {
        self.authRepository = authRepository
        self.workspaceRepository = workspaceRepository
        self.appState = appState
    }
}

extension DefaultAutoLoginUseCase: AutoLoginUseCase {
    func excute() async throws {
        let platform = appState.loginInfo.loginType
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
        let workspaceList = try await workspaceRepository.fetchComeInWorkspaceList()
        await MainActor.run {
            appState.workspaceList = workspaceList.list
            appState.isLoggedIn = true
        }
    }
}
