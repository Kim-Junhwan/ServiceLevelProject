//
//  LoginViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/05.
//

import Foundation

final class LoginViewModel: ViewModel {
    
    struct LoginState {
        var error: Error?
        var isLoading: Bool = false
        var successLogin: Bool = false
    }
    
    enum LoginInput {
        case appleLogin
        case kakaoLogin
    }
    
    @Published var state: LoginState
    
    init() {
        state = LoginState()
    }
    
    func trigger(_ input: LoginInput) {
        
    }
    
    
}
