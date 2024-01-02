//
//  OnBoardingView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/02.
//

import SwiftUI

struct OnBoardingView: View {
    
    var body: some View {
        ZStack {
            SplashScreenView()
            VStack {
                Spacer()
                RoundedButton(action: {
                    
                }, label: {
                    Text("시작하기")
                }, backgroundColor: .brandGreen )
                .padding(24)

            }
        }
    }
}

#Preview {
    OnBoardingView()
}
