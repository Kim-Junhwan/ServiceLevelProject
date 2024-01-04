//
//  RegisterView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/03.
//

import SwiftUI

struct RegisterView: View {
    
    @FocusState var isFocus: Bool
    @State var email: String = ""
    @Binding var isPresenting: Bool
    @State var canRegister: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack (spacing: 24) {
                        TitleTextField(title: "이메일", placeHolder: "이메일을 입력하세요", kind: .textField, textFieldTitle: $email, splitView: {
                            RoundedButton(action: {
                                
                            }, label: {
                                Text("중복확인")
                            }, backgroundColor: canRegister ? .brandGreen : .brandInactive)
                            .frame(width: 100)
                        })
                            .focused($isFocus)
                        
                        TitleTextField(title: "닉네임", placeHolder: "닉네임을 입력하세요", kind: .textField, textFieldTitle: $email)
                            .focused($isFocus)
                        
                        TitleTextField(title: "연락처", placeHolder: "전화번호를 입력하세요", kind: .textField, textFieldTitle: $email)
                            .focused($isFocus)
                        
                        TitleTextField(title: "비밀번호", placeHolder: "비밀번호을 입력하세요", kind: .secureField, textFieldTitle: $email)
                            .focused($isFocus)
                        
                        TitleTextField(title: "비밀번호 확인", placeHolder: "비밀번호를 한번 더 입력하세요", kind: .secureField, textFieldTitle: $email)
                            .focused($isFocus)
                        Spacer()
                    }
                    .padding(24)
                }
                
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        if isFocus {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.seperator)
                        }
                            
                        RoundedButton(action: {
                            
                        }, label: {
                            Text("가입하기")
                        }, backgroundColor: canRegister ? .brandGreen : .brandInactive)
                        .padding([.top, .bottom], 12)
                        .padding([.leading, .trailing], 24)
                        .background(
                            Color.backgroundPrimary
                    )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
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
