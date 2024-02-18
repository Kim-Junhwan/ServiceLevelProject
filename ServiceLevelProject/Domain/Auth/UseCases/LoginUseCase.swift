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
    let workspaceRepository: WorkspaceRepository
    let appState: AppState
    
    init(authRepository: AuthRepository, workspaceRepository: WorkspaceRepository, appState: AppState) {
        self.authRepository = authRepository
        self.workspaceRepository = workspaceRepository
        self.appState = appState
    }
}

extension DefaultLoginUseCase: LoginUseCase {
    func excute(_ platform: LoginType) async throws {
        let userProfile = try await platformLogin(platform)
        appState.setLoginInfo(userProfile: userProfile)
        let workspaceList = try await workspaceRepository.fetchComeInWorkspaceList()
        await updateAppstate(workspaceList: workspaceList)
    }
    
    @MainActor
    private func updateAppstate(workspaceList: WorkspaceList) async {
        appState.workspaceList = workspaceList.list
        appState.isLoggedIn = true
    }
    
    private func platformLogin(_ platform: LoginType) async throws -> RegistUserProfile {
        let deviceToken = appState.deviceToken
        switch platform {
        case .apple(let idToken, let nickName):
            appState.loginInfo.loginType = .apple(idToken: idToken)
            return try await authRepository.appleLogin(.init(idToken: idToken, nickName: nickName, deviceToken: deviceToken))
        case .kakao:
            let info = try await KakaoLoginManager().login()
            appState.loginInfo.loginType = .kakao(oauthToken: info)
            return try await authRepository.kakaoLogin(.init(oauthToken: info, deviceToken: deviceToken))
        case .email(let email, let password):
            appState.loginInfo.loginType = .email(email: email, password: password)
            return try await authRepository.emailLogin(.init(email: email, password: password, deviceToken: deviceToken))
        case .none:
            fatalError()
        }
    }
}
