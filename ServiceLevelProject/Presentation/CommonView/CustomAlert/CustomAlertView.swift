//
//  CustomAlertView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/12.
//

import SwiftUI

extension View {
    
    func customAlert<T: View>(isPresenting: Binding<Bool>, title: String, description: String? = nil, buttonStackView: @escaping () -> T) -> some View {
        let keywindow = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = keywindow.windows.first!
        let vc = UIHostingController(rootView: CustomAlertView(title: title, description: description, buttonStackView: buttonStackView))
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = .clear
        
        return self.onChange(of: isPresenting.wrappedValue) {
            if $0 {
                window.rootViewController?.present(vc, animated: false)
            } else {
                window.rootViewController?.dismiss(animated: false)
            }
        }
    }
}

struct CustomAlertView<AlertButtonView: View>: View {
    
    let title: String
    var description: String? = nil
    let buttonStackView: ()-> AlertButtonView
    
    var body: some View {
        ZStack {
            Color
                .black
                .ignoresSafeArea()
                .opacity(0.3)
            VStack {
                VStack(spacing: 8) {
                    Text(title)
                        .font(CustomFont.title2.font)
                    Text(description ?? "")
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 10)
                        .font(CustomFont.body.font)
                        .foregroundStyle(.textSecondary)
                }
                HStack(spacing: 8) {
                    buttonStackView()
                }
            }
            .padding(16)
            .background {
                Rectangle()
                    .fill(.white)
                    .clipShape(.rect(cornerRadius: 16))
            }
            .frame(width: 344)
            .background(.clear)
        }
    }
}

#Preview {
    CustomAlertView(title: "고양이", description: "강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워강아지는 귀여워") {
        HStack {
            RoundedButton(action: {
                
            }, label: {
                Text("Hello")
            }, backgroundColor: .brandGreen)
            
            RoundedButton(action: {
                
            }, label: {
                Text("Hello")
            }, backgroundColor: .brandGreen)
        }
        
    }
}
