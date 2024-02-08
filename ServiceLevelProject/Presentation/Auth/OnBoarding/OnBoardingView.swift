//
//  OnBoardingView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/02.
//

import SwiftUI

struct OnBoardingView: View {
    
    @State var showRegisterView: Bool = false
    
    var body: some View {
        ZStack {
            SplashScreenView()
            VStack {
                Spacer()
                RoundedButton(action: {
                    showRegisterView.toggle()
                }, label: {
                    Text("시작하기")
                }, backgroundColor: .brandGreen )
                .padding(24)
            }
        }
        .background(.backgroundPrimary)
        .sheet(isPresented: $showRegisterView, content: {
            LoginView()
        })
    }
}

#Preview {
    OnBoardingView()
}
