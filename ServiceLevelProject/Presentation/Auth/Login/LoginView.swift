//
//  SocialLoginView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/03.
//

import Foundation
import SwiftUI
import _AuthenticationServices_SwiftUI

struct LoginView: View {
    
    @State private var showRegisterView: Bool = false
    @State private var showEmailLoginView: Bool = false
    @ObservedObject var viewModel: SocialLoginViewModel
    
    var appleLoginButton: some View {
        SignInWithAppleButton(onRequest: { request in
            request.requestedScopes = [.fullName]
        }, onCompletion: { result in
            switch result {
            case .success(let auth):
                guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential,
                      let fullName = appleIDCredential.fullName,
                      let identityToken = appleIDCredential.identityToken else { return }
                viewModel.trigger(.appleLogin(idToken: identityToken, nickName: fullName))
            case .failure(_):
                break
            }
        })
        .frame(height: 44)
    }
    
    var body: some View {
        VStack (spacing: 16) {
            appleLoginButton
            
            RoundedButton(action: {
                viewModel.trigger(.kakaoLogin)
            }, label: {
                HStack (spacing: 8) {
                    Image(.kakaoLogo)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("카카오톡으로 계속하기")
                        .foregroundStyle(.black)
                }
            }, backgroundColor: .kakaoYellow)
            
            RoundedButton(action: {
                showEmailLoginView.toggle()
            }, label: {
                HStack (spacing: 4) {
                    Image(.email)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("이메일로 계속하기")
                }
            }, backgroundColor: .brandGreen)
            
            HStack(spacing: 0) {
                Text("또는")
                Button(" 새롭게 회원가입 하기") {
                    showRegisterView.toggle()
                }
                .foregroundStyle(.brandGreen)
            }
        }
        .padding([.leading, .trailing], 35)
        .defaultBackground()
        .presentationDetents([.height(290)])
        .presentationDragIndicator(.visible)
        .font(CustomFont.title2.font)
        .sheet(isPresented: $showRegisterView, content: {
            viewModel.diContainer.makeRegisterView(presenting: $showRegisterView)
        })
        .sheet(isPresented: $showEmailLoginView, content: {
            EmailLoginView(isPresenting: $showEmailLoginView, viewModel: EmailLoginViewModel())
        })
    }
}

#Preview {
    LoginView(viewModel: .init(authDIContainer: .init()))
}
