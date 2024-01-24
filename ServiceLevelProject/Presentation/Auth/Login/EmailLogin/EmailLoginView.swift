//
//  EmailLoginView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/07.
//

import SwiftUI

struct EmailLoginView: View {
    
    enum FocusTextField {
        case email
        case password
    }
    
    @FocusState private var focusFeild: FocusTextField?
    @Binding var isPresenting: Bool
    @ObservedObject var viewModel: EmailLoginViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack (spacing: 24) {
                    TitleTextField(title: "이메일", isValid: $viewModel.state.isValidEmail, placeHolder: "이메일을 입력하세요", kind: .textField, textFieldTitle: $viewModel.email)
                        .focused($focusFeild, equals: .email)
                    
                    TitleTextField(title: "비밀번호", isValid: $viewModel.state.isValidPassword, placeHolder: "비밀번호를 입력하세요", kind: .secureField, textFieldTitle: $viewModel.password)
                        .focused($focusFeild, equals: .password)
                    
                    Spacer()
                }
                .padding(24)
                VStack {
                    Spacer()
                        .toastView(toast: $viewModel.state.toastMessage)
                    KeyboardStickeyButton(isFocus: .constant(focusFeild != nil) , title: "로그인", isEnable: .constant(!viewModel.email.isEmpty && !viewModel.password.isEmpty)) {
                        viewModel.trigger(.tapLoginButton)
                        if !viewModel.state.isValidEmail {
                            focusFeild = .email
                        } else if !viewModel.state.isValidPassword {
                            focusFeild = .password
                        }
                    }
                }
            }
            .defaultBackground()
            .underlineNavigationBar(title: "이메일로 로그인")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresenting.toggle()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    })
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    EmailLoginView(isPresenting: .constant(true), viewModel: .init(loginUseCase: MockLoginUseCase()))
}
