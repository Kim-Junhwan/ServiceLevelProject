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
        
        container.register(LoginUseCase.self) { resolver in
            let workspaceRepository = resolver.resolve(WorkspaceRepository.self)!
            return DefaultLoginUseCase(authRepository: authRepository, workspaceRepository: workspaceRepository, appState: appState)
        }
        
        container.register(CheckEmailUseCase.self) { _ in
            return DefaultCheckEmailUseCase(authRepository: authRepository)
        }
        
        container.register(AutoLoginUseCase.self) { resolver in
            let workspaceRepository = resolver.resolve(WorkspaceRepository.self)!
            return DefaultAutoLoginUseCase(authRepository: authRepository, workspaceRepository: workspaceRepository, appState: appState)
        }
    }
}
