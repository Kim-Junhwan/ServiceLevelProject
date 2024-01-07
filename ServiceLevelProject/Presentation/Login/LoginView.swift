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
    
    private var appleLoginAction: ((Result<ASAuthorization, Error>) -> Void) = { result in
        switch result {
        case .success(let auth):
            guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential,
                  let fullName = appleIDCredential.fullName,
                  let identityToken = appleIDCredential.identityToken else { return }
        case .failure(_):
            break
        }
    }
    
    var body: some View {
        VStack (spacing: 16) {
            
            SignInWithAppleButton(onRequest: { request in
                request.requestedScopes = [.fullName]
            }, onCompletion: appleLoginAction)
            .frame(height: 44)
            
            RoundedButton(action: {
                
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.leading, .trailing], 35)
        .background(.backgroundPrimary)
        .presentationDetents([.height(290)])
        .presentationDragIndicator(.visible)
        .font(CustomFont.title2.font)
        .sheet(isPresented: $showRegisterView, content: {
            RegisterView(isPresenting: $showRegisterView)
        })
    }
}

#Preview {
    LoginView()
}
