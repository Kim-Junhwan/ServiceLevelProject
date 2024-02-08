//
//  LoginViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/05.
//

import Foundation

final class SocialLoginViewModel: ViewModel {
    
    struct LoginState {
        var toast: Toast?
        var isLoading: Bool = false
        var successLogin: Bool = false
    }
    
    enum SocialLoginInput {
        case appleLogin(idToken: Data, nickName: PersonNameComponents)
        case kakaoLogin
    }
    
    @Published var state: LoginState
    let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.state = LoginState()
        self.loginUseCase = loginUseCase
    }
    
    func trigger(_ input: SocialLoginInput) {
        Task { @MainActor in
            do {
                switch input {
                case .appleLogin(let idToken, let nickName):
                    try await appleLogin(idToken: idToken ,nickName: nickName)
                case .kakaoLogin:
                    try await loginUseCase.excute(.kakao)
                }
            } catch {
                self.state.toast = Toast(message: error.localizedDescription, duration: 1.0)
            }
        }
    }
    
    private func appleLogin(idToken: Data, nickName: PersonNameComponents) async throws {
        guard let idToken = String(data: idToken, encoding: .utf8) else { return }
        var registNickName: String?
        if let familyName = nickName.familyName, let givenName = nickName.givenName {
            registNickName = "\(familyName)\(givenName)"
        }
        try await loginUseCase.excute(.apple(idToken: idToken, nickName: registNickName))
    }
}
