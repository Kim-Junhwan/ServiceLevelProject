//
//  AuthDomainAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/08.
//

import Foundation
import Swinject

final class AuthDomainAssembly: Assembly {
    func assemble(container: Container) {
        registerUseCases(container: container)
    }
    
    private func registerUseCases(container: Container) {
        let authRepository = container.resolve(AuthRepository.self)!
        let appState = container.resolve(AppState.self)!
        
        container.register(RegisterUserUseCase.self) { _ in
            return DefaultRegisterUserUseCase(authRepository: authRepository, appState: appState)
        }
        
        container.register(LoginUseCase.self) { _ in
            return DefaultLoginUseCase(authRepository: authRepository, appState: appState)
        }
        
        container.register(CheckEmailUseCase.self) { _ in
            return DefaultCheckEmailUseCase(authRepository: authRepository)
        }
        
        container.register(AutoLoginUseCase.self) { _ in
            return DefaultAutoLoginUseCase(authRepository: authRepository, appState: appState)
        }
    }
}
