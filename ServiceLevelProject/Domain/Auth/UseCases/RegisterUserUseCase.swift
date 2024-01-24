//
//  RegisterUserUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/14.
//

import Foundation

protocol RegisterUserUseCase {
    func excute(_ query: RegisterUserRequestQuery) async throws
}

final class DefaultRegisterUserUseCase {
    let authRepository: AuthRepository
    let appState: AppState
    
    init(authRepository: AuthRepository, appState: AppState) {
        self.authRepository = authRepository
        self.appState = appState
    }
}

extension DefaultRegisterUserUseCase: RegisterUserUseCase {
    func excute(_ query: RegisterUserRequestQuery) async throws {
        let registedUserInfo = try await authRepository.registerUser(query)
        self.appState.loginInfo.loginType = .email(email: query.email, password: query.password)
        self.appState.token.accessToken = registedUserInfo.accessToken
        self.appState.token.refreshToken = registedUserInfo.refreshToken
        await appState.setLoginStatus(true)
    }
}
