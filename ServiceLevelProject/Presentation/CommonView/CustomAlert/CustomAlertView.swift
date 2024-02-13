//
//  CustomAlertView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/12.
//

import SwiftUI

extension View {
    
    func customAlert(title: String, description: String? = nil, actionTitle: String, isPresenting: Binding<Bool>, action: @escaping ()-> Void) -> some View {
        let vc = UIHostingController(rootView: CustomAlertView(title: title, description: description, actionTitle: actionTitle, isPresenting: isPresenting, action: action))
        return presentCustomAlertView(isPresenting: isPresenting, vc: vc)
    }
    
    func customAlert(title: String, description: String? = nil, cancelTitle: String, actionTitle: String, isPresenting: Binding<Bool>, action: @escaping ()-> Void) -> some View {
        
        let vc = UIHostingController(rootView: CustomAlertView(title: title, description: description, cancelTitle: cancelTitle, actionTitle: actionTitle, isPresenting: isPresenting, action: action))
       return presentCustomAlertView(isPresenting: isPresenting, vc: vc)
    }
    
    private func presentCustomAlertView(isPresenting: Binding<Bool>,vc: UIViewController) -> some View {
        let keywindow = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = keywindow.windows.first!
        
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

struct CustomAlertView: View {
    
    enum AlertType {
        case ok(title: String)
        case cancelOk(cancelTitle: String, okTitle: String)
    }
    
    let title: String
    var description: String? = nil
    let type: AlertType
    let action: () -> Void
    @Binding var isPresenting: Bool
    
    init(title: String, description: String? = nil, cancelTitle: String, actionTitle: String, isPresenting: Binding<Bool>, action: @escaping ()-> Void) {
        self.title = title
        self._isPresenting = isPresenting
        self.description = description
        self.action = action
        self.type = .cancelOk(cancelTitle: cancelTitle, okTitle: actionTitle)
    }
    
    init(title: String, description: String? = nil, actionTitle: String, isPresenting: Binding<Bool>, action: @escaping ()-> Void) {
        self.title = title
        self._isPresenting = isPresenting
        self.description = description
        self.action = action
        self.type = .ok(title: actionTitle)
    }
    
    @ViewBuilder
    var buttonStackView: some View {
        switch type {
        case .ok(let title):
            HStack {
                RoundedButton(action: {
                    isPresenting = false
                }, label: {
                    Text(title)
                }, backgroundColor: .brandGreen)
                
            }
        case .cancelOk(let cancelTitle, let okTitle):
            HStack(spacing: 8) {
                RoundedButton(action: {
                    isPresenting = false
                }, label: {
                    Text(cancelTitle)
                }, backgroundColor: .brandInactive)
                
                RoundedButton(action: {
                    action()
                }, label: {
                    Text(okTitle)
                }, backgroundColor: .brandGreen)
            }
        }
    }
    
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
                    buttonStackView
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
    CustomAlertView(title: "고양이", actionTitle: "확인", isPresenting: .constant(true)) {
        print("Hello")
    }
}
