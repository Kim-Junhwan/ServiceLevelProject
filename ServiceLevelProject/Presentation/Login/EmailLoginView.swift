//
//  EmailLoginView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/07.
//

import SwiftUI

struct EmailLoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var isFocus: Bool
    @State private var canLogin: Bool = false
    @Binding var isPresenting: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack (spacing: 24) {
                    TitleTextField(title: "이메일", placeHolder: "이메일을 입력하세요", kind: .textField, textFieldTitle: $email)
                        .focused($isFocus)
                    TitleTextField(title: "비밀번호", placeHolder: "비밀번호를 입력하세요", kind: .secureField, textFieldTitle: $password)
                        .focused($isFocus)
                    Spacer()
                }
                .padding(24)
                VStack {
                    Spacer()
                    KeyboardStickeyButton(isFocus: $isFocus, title: "로그인", isEnable: $canLogin)
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
    EmailLoginView(isPresenting: .constant(true))
}
