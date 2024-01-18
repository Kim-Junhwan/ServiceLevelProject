//
//  AuthorizationSceneDIContainer.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/18.
//

import Foundation
import SwiftUI

final class AuthorizationSceneDIContainer {
    
    lazy var userLoginStatusManager: UserLoginStatusManager = {
       return UserLoginStatusManager()
    }()
    
    func makeRegisterUseCase() -> RegisterUserUseCase {
        return DefaultRegisterUserUseCase(authRepository: makeAuthRepository(), loginInfoRepository: userLoginStatusManager)
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
        return LoginView(viewModel: .init(authDIContainer: self))
    }
}
