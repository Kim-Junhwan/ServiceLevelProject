//
//  EmailLoginViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/08.
//

import Foundation

final class EmailLoginViewModel: ViewModel {
    
    struct EmailLoginState {
        var toastMessage: Toast?
        var isLoading: Bool = false
        var successLogin: Bool = false
        var isValidEmail: Bool = true
        var isValidPassword: Bool = true
    }
    
    enum EmailLoginInput {
        case tapLoginButton
    }
    
    @Published var state: EmailLoginState
    @Published var email: String = ""
    @Published var password: String = ""
    
    let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        state = EmailLoginState()
        self.loginUseCase = loginUseCase
    }
    
    func trigger(_ input: EmailLoginInput) {
        switch input {
        case .tapLoginButton:
            if checkValidate() {
                emailLogin()
            }
        }
    }
    
    private func checkValidate() -> Bool {
        let emailValid = Validator.isValid(category: .email, email)
        let passwordValid = Validator.isValid(category: .password, password)
        state.isValidEmail = emailValid
        state.isValidPassword = passwordValid
        if !emailValid {
            state.toastMessage = .init(message: "이메일 형식이 옳바르지 않습니다.", duration: 1.0)
        } else if !passwordValid {
            state.toastMessage = .init(message: "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요.", duration: 1.0)
        }
        return emailValid && passwordValid
    }
    
    private func emailLogin() {
        Task { @MainActor in
            do{
                try await loginUseCase.excute(.email(email: email, password: password))
            } catch {
                self.state.toastMessage = .init(message: error.localizedDescription, duration: 1.0)
            }
        }
    }
    
}
