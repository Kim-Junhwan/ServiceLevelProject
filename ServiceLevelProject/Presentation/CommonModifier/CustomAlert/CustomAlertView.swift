//
//  CustomAlertView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/12.
//

import SwiftUI

struct AlertMessage {
    let title: String
    var description: String? = nil
    let type: CustomAlertView.AlertType
    let action: () -> Void
    let dismissAction: (() -> Void)? 
    
    init(title: String, description: String? = nil, type: CustomAlertView.AlertType, action: @escaping () -> Void,  dismissAction: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.type = type
        self.action = action
        self.dismissAction = dismissAction
    }
}

extension View {
    func customAlert(alertMessage: Binding<AlertMessage?>) -> some View {
        modifier(CustomAlertViewModifier(alertMessage: alertMessage))
    }
}

private struct CustomAlertViewModifier: ViewModifier {
    
    @Binding var alertMessage: AlertMessage?
    
    @ViewBuilder
    func contentView() -> some View {
        if let alertMessage {
            CustomAlertView(title: alertMessage.title, description: alertMessage.description, type: alertMessage.type, action: alertMessage.action, dismissAction: alertMessage.dismissAction, alertMessage: $alertMessage)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: .constant(alertMessage != nil), content: {
                contentView()
                    .background(FullScreenCoverBackgroundRemovalView())
                
            })
//            .transaction { transaction in
//                transaction.disablesAnimations = true
//            }
    }
}

private struct FullScreenCoverBackgroundRemovalView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
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
    let dismissAction: (() -> Void)?
    @Binding var alertMessage: AlertMessage?
    
    init(title: String, description: String? = nil, type: AlertType, action: @escaping () -> Void, dismissAction: (() -> Void)? = nil, alertMessage: Binding<AlertMessage?>) {
        self.title = title
        self.description = description
        self.type = type
        self.action = action
        self.dismissAction = dismissAction
        self._alertMessage = alertMessage
    }
    
    @ViewBuilder
    var buttonStackView: some View {
        switch type {
        case .ok(let title):
            HStack {
                RoundedButton(action: {
                    alertMessage = nil
                }, label: {
                    Text(title)
                }, backgroundColor: .brandGreen)
                
            }
        case .cancelOk(let cancelTitle, let okTitle):
            HStack(spacing: 8) {
                RoundedButton(action: {
                    alertMessage = nil
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
                        .foregroundStyle(.textPrimary)
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
        .onDisappear {
            dismissAction?()
        }
    }
}


