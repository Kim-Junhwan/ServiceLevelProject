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
    
    var body: some View {
        VStack (spacing: 16) {
            RoundedButton(action: {
                
            }, label: {
                HStack (spacing: 5) {
                    Image(.appleLogo)
                        .resizable()
                        .scaledToFit()
                    Text("Apple로 계속하기")
                }
            }, backgroundColor: .appleBlack)
            .frame(height: 44)
            
            SignInWithAppleButton { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let auth):
                    switch auth.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        let userIdentifier = appleIDCredential.user
                        let fullName = appleIDCredential.fullName
                        let email = appleIDCredential.email
                        print(fullName)
                        print(appleIDCredential.identityToken)
                    default:
                        break
                    }
                case .failure(_):
                    break
                }
            }
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
