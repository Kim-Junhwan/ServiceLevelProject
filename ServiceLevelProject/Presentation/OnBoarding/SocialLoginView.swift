//
//  SocialLoginView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/03.
//

import Foundation
import SwiftUI

struct SocialLoginView: View {
    
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
    }
}

#Preview {
    SocialLoginView()
}
