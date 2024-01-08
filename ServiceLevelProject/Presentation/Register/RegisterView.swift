//
//  RegisterView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/03.
//

import SwiftUI

struct RegisterView: View {
    
    enum FocusTextField {
        case email
        case nick
        case phoneNumber
        case password
        case checkPassword
    }
    
    @FocusState var isFocus: Bool
    @Binding var isPresenting: Bool
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack (spacing: 24) {
                        TitleTextField(title: "이메일", isValid: $viewModel.state.isValidEmail, placeHolder: "이메일을 입력하세요", kind: .textField, textFieldTitle: $viewModel.email, splitView: {
                            RoundedButton(action: {
                                
                            }, label: {
                                Text("중복확인")
                            }, backgroundColor: !viewModel.email.isEmpty ? .brandGreen : .brandInactive)
                            .frame(width: 100)
                            .disabled(viewModel.email.isEmpty)
                        })
                            .focused($isFocus)
                        
                        TitleTextField(title: "닉네임", isValid: $viewModel.state.isValidNick, placeHolder: "닉네임을 입력하세요", kind: .textField, textFieldTitle: $viewModel.nick)
                            .focused($isFocus)
                        
                        TitleTextField(title: "연락처", isValid: $viewModel.state.isValidPhoneNumber, placeHolder: "전화번호를 입력하세요", kind: .textField, textFieldTitle: $viewModel.phoneNumber)
                            .focused($isFocus)
                        
                        TitleTextField(title: "비밀번호", isValid: $viewModel.state.isValidPassword, placeHolder: "비밀번호을 입력하세요", kind: .secureField, textFieldTitle: $viewModel.password)
                            .focused($isFocus)
                        
                        TitleTextField(title: "비밀번호 확인", isValid: $viewModel.state.passwordIsSame, placeHolder: "비밀번호를 한번 더 입력하세요", kind: .secureField, textFieldTitle: $viewModel.checkPassword)
                            .focused($isFocus)
                        Spacer()
                    }
                    .padding(24)
                }
                
                VStack {
                    Spacer()
                        .toastView(toast: $viewModel.state.toastMessage)
                    KeyboardStickeyButton(isFocus: .constant(true), title: "가입하기", isEnable: $viewModel.state.canTapRegisterButton) {
                        viewModel.trigger(.tapRegisterButton)
                        
                    }
                }
            }
            .defaultBackground()
            .underlineNavigationBar(title: "회원가입")
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
        }//NavigationStack
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    RegisterView(isPresenting: .constant(true))
}
