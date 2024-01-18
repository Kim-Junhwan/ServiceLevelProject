//
//  CheckEmailUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/18.
//

import Foundation

protocol CheckEmailUseCase {
    func excute(email: String) async throws
}

final class DefaultCheckEmailUseCase {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension DefaultCheckEmailUseCase: CheckEmailUseCase {
    func excute(email: String) async throws {
        try await authRepository.checkValidateEmail(email: email)
    }
}
