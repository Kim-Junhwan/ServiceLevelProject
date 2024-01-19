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
    let loginInfoRepository: LoginInfoRepository
    
    init(authRepository: AuthRepository, loginInfoRepository: LoginInfoRepository) {
        self.authRepository = authRepository
        self.loginInfoRepository = loginInfoRepository
    }
}

extension DefaultRegisterUserUseCase: RegisterUserUseCase {
    func excute(_ query: RegisterUserRequestQuery) async throws {
        let registedUserInfo = try await authRepository.registerUser(query)
        loginInfoRepository.loginType = .email(email: query.email, password: query.password)
        try loginInfoRepository.saveToken(accessToken: registedUserInfo.accessToken, refreshToken: registedUserInfo.refreshToken)
    }
}
