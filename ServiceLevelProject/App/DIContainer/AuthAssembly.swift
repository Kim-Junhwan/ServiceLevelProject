//
//  AuthAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/08.
//

import Foundation
import Swinject

final class AuthAssembly: Assembly {
    func assemble(container: Container) {
        registerUseCases(container: container)
        registerViewModel(container: container)
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
    
    func registerViewModel(container: Container) {
        container.register(SocialLoginViewModel.self) { resolver in
            return SocialLoginViewModel(loginUseCase: resolver.resolve(LoginUseCase.self)!)
        }
        
        container.register(EmailLoginViewModel.self) { resolver in
            return EmailLoginViewModel(loginUseCase: resolver.resolve(LoginUseCase.self)!)
        }
        
        container.register(ContentViewModel.self) { resolver in
            return ContentViewModel(loginUseCase: resolver.resolve(AutoLoginUseCase.self)!)
        }
        
        container.register(RegisterViewModel.self) { resolver in
            let checkEmailUseCase = resolver.resolve(CheckEmailUseCase.self)!
            let registerUseCase = resolver.resolve(RegisterUserUseCase.self)!
            return RegisterViewModel(checkEmailUseCase: checkEmailUseCase, registerUseCase: registerUseCase)
        }
    }
}
