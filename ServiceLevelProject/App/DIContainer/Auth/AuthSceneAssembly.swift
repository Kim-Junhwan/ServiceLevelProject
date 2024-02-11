//
//  AuthSceneAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/09.
//

import Swinject

final class AuthSceneAssembly: Assembly {
    func assemble(container: Container) {
        let appState = container.resolve(AppState.self)!
        container.register(SocialLoginViewModel.self) { resolver in
            return SocialLoginViewModel(loginUseCase: resolver.resolve(LoginUseCase.self)!)
        }
        
        container.register(EmailLoginViewModel.self) { resolver in
            return EmailLoginViewModel(loginUseCase: resolver.resolve(LoginUseCase.self)!)
        }
        
        container.register(ContentViewModel.self) { resolver in
            return ContentViewModel(loginUseCase: resolver.resolve(AutoLoginUseCase.self)!, appState: appState)
        }
        
        container.register(RegisterViewModel.self) { resolver in
            let checkEmailUseCase = resolver.resolve(CheckEmailUseCase.self)!
            let registerUseCase = resolver.resolve(RegisterUserUseCase.self)!
            return RegisterViewModel(checkEmailUseCase: checkEmailUseCase, registerUseCase: registerUseCase)
        }
    }
}
