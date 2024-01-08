//
//  RegisterViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/08.
//

import Foundation
import Combine

final class RegisterViewModel: ViewModel {
    
    struct RegisterState {
        var toastMessage: Toast?
        var isValidEmail: Bool = true
        var isValidNick: Bool = true
        var isValidPhoneNumber: Bool = true
        var isValidPassword: Bool = true
        var passwordIsSame: Bool = true
        var canTapRegisterButton: Bool = false
        var checkedValidEmail: Bool = false
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
    
    private var canTapRegisterButton: AnyPublisher<Bool, Never> {
        return $email
            .combineLatest($nick, $password, $checkPassword)
            .map { email, nick, password, checkPassword in
                return !email.isEmpty && !nick.isEmpty && !password.isEmpty && !checkPassword.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        self.state = RegisterState()
        canTapRegisterButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: { value in
                self.state.canTapRegisterButton = value
            })
            .store(in: &cancellableBag)
    }
    
    func trigger(_ input: RegisterInput) {
        switch input {
        case .checkDuplication:
            if checkValidate() {
                
            }
        case .tapRegisterButton:
            if checkValidate() {
                
            }
        }
    }
    
    private func checkEmailValidate() -> Bool {
        if email == validatedEmail {
            state.toastMessage = .init(message: "사용 가능한 이메일입니다.", duration: 1.0)
            return false
        }
        let emailValid = Validator.isValid(category: .email, email)
        return emailValid
    }
    
    private func checkValidate() -> Bool {
        let checkedEmailValid = state.checkedValidEmail
        let nickValid = Validator.isValid(category: .nick, nick)
        let phoneNumberValid = phoneNumber.isEmpty ? true : Validator.isValid(category: .phoneNumber, phoneNumber)
        let passwordValid = Validator.isValid(category: .password, password)
        let checkPasswordValid = password == checkPassword
        return checkedEmailValid && nickValid && phoneNumberValid && passwordValid && checkPasswordValid
    }
}
