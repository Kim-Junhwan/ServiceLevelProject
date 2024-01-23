//
//  AuthorizationSceneDIContainer.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/18.
//

import Foundation
import SwiftUI

final class AuthorizationSceneDIContainer: ObservableObject {
    
    @Published var appState: AppState = AppState()
    
    func makeRegisterUseCase() -> RegisterUserUseCase {
        return DefaultRegisterUserUseCase(authRepository: makeAuthRepository(), appState: appState)
    }
    
    func makeLoginUseCase() -> LoginUseCase {
        return DefaultLoginUseCase(authRepository: makeAuthRepository(), appState: appState)
    }
    
    func makeCheckEmailUseCase() -> CheckEmailUseCase {
        return DefaultCheckEmailUseCase(authRepository: makeAuthRepository())
    }
    
    func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository()
    }
    
    func makeRegisterView(presenting: Binding<Bool>) -> some View {
        return RegisterView(isPresenting: presenting, viewModel: .init(authDIContainer: self, checkEmailUseCase: self.makeCheckEmailUseCase(), registerUseCase: self.makeRegisterUseCase()))
    }
    
    func makeLoginView() -> some View {
        return LoginView(viewModel: .init(loginUseCase: makeLoginUseCase(), diContainer: self))
    }
}
