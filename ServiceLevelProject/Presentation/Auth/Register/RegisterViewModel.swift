//
//  RegisterViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/08.
//

import Foundation
import Combine

final class RegisterViewModel: ViewModel {
    
    enum FocusTextField {
        case email
        case nick
        case phoneNumber
        case password
        case checkPassword
    }
    
    struct RegisterState {
        var toastMessage: Toast?
        var focusField: FocusTextField?
        var isValidEmail: Bool = true
        var isValidNick: Bool = true
        var isValidPhoneNumber: Bool = true
        var isValidPassword: Bool = true
        var passwordIsSame: Bool = true
        var canTapRegisterButton: Bool = false
        var checkedValidEmail: Bool = true
        var registerSuccess: Bool = false
    }
    
    enum RegisterInput {
        case checkDuplication
        case tapRegisterButton
    }
    
    private var cancellableBag = Set<AnyCancellable>()
    
    @Published var state: RegisterState
    @Published var email: String = ""
    @Published var nick: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var checkPassword: String = ""
    private var validatedEmail: String = ""
    private var originPhoneNumber: String = ""
    
    var diContainer: AuthorizationSceneDIContainer
    let checkEmailUseCase: CheckEmailUseCase
    let registerUseCase: RegisterUserUseCase
    
    init(authDIContainer: AuthorizationSceneDIContainer, checkEmailUseCase: CheckEmailUseCase, registerUseCase: RegisterUserUseCase) {
        self.state = State()
        self.checkEmailUseCase = checkEmailUseCase
        self.diContainer = authDIContainer
        self.registerUseCase = registerUseCase
        
        $email
            .combineLatest($nick, $password, $checkPassword)
            .map { email, nick, password, checkPassword in
                return !email.isEmpty && !nick.isEmpty && !password.isEmpty && !checkPassword.isEmpty
            }
            .sink { value in
                self.state.canTapRegisterButton = value
            }
            .store(in: &cancellableBag)
        
        $phoneNumber.receive(on: RunLoop.main)
            .sink { value in
                var removeHypenNumber = value.components(separatedBy: ["-"]).joined()
                if removeHypenNumber.count > 11 {
                    removeHypenNumber.removeLast()
                }
                self.originPhoneNumber = removeHypenNumber
                self.phoneNumber = self.originPhoneNumber.withHypen
            }
            .store(in: &cancellableBag)
    }
    
    func trigger(_ input: RegisterInput) {
        switch input {
        case .checkDuplication:
            if checkEmailValidate() {
                checkEmail()
            }
        case .tapRegisterButton:
            if checkValidate() {
                registerUser()
            }
        }
    }
    
    func checkEmail() {
        Task { @MainActor in
            do {
                try await checkEmailUseCase.excute(email: email)
                state.toastMessage = .init(message: "사용할 수 있는 이메일입니다.", duration: 1.0)
                validatedEmail = email
            } catch {
                state.toastMessage = .init(message: error.localizedDescription, duration: 1.0)
            }
        }
    }
    
    private func checkEmailValidate() -> Bool {
        if email == validatedEmail {
            state.toastMessage = .init(message: "사용 가능한 이메일입니다.", duration: 1.0)
            return false
        }
        let emailValid = Validator.isValid(category: .email, email)
        if !emailValid {
            state.toastMessage = .init(message: "이메일 형식이 옳바르지 않습니다.", duration: 1.0)
        }
        return emailValid
    }
    
    private func checkValidate() -> Bool {
        let checkedEmailValid = state.checkedValidEmail
        let nickValid = Validator.isValid(category: .nick, nick)
        let phoneNumberValid = phoneNumber.isEmpty ? true : Validator.isValid(category: .phoneNumber, phoneNumber)
        let passwordValid = Validator.isValid(category: .password, password)
        let checkPasswordValid = password == checkPassword
        state.isValidEmail = checkedEmailValid
        state.isValidNick = nickValid
        state.isValidPhoneNumber = phoneNumberValid
        state.isValidPassword = passwordValid
        state.passwordIsSame = checkPasswordValid
        if !checkedEmailValid {
            state.toastMessage = .init(message: "이메일 중복 확인을 진행해주세요.", duration: 1.0)
            state.focusField = .email
        } else if !nickValid {
            state.toastMessage = .init(message: "닉네임은 1글자 이상 30글자 이내로 부탁드려요.", duration: 1.0)
            state.focusField = .nick
        } else if !phoneNumberValid {
            state.toastMessage = .init(message: "잘못된 전화번호 형식입니다.", duration: 1.0)
            state.focusField = .phoneNumber
        } else if !passwordValid {
            state.toastMessage = .init(message: "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요.", duration: 1.0)
            state.focusField = .password
        } else if !checkPasswordValid {
            state.toastMessage = .init(message: "작성하신 비밀번호가 일치하지 않습니다.", duration: 1.0)
            state.focusField = .checkPassword
        }
        return checkedEmailValid && nickValid && phoneNumberValid && passwordValid && checkPasswordValid
    }
    
    func registerUser() {
        Task { @MainActor in
            do {
                let query = RegisterUserRequestQuery(email: email, password: password, nickName: nick, phoneNumber: phoneNumber, deviceToken: "")
                try await registerUseCase.excute(query)
                self.state.registerSuccess = true
            } catch {
                state.toastMessage = .init(message: error.localizedDescription, duration: 1.0)
            }
        }
    }
}
