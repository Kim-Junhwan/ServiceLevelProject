//
//  Toast.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/05.
//

import Foundation
import SwiftUI

struct Toast: Equatable {
    let message: String
    let duration: Double
}

struct ToastView: View {
    
    var message: String
    
    var body: some View {
        Text(message)
            .frame(height: 44)
            .padding([.leading, .trailing], 16)
            .foregroundStyle(.white)
            .background(.brandGreen)
            .clipShape(.rect(cornerRadius: 8))
            .font(CustomFont.body.font)
    }
}

struct ToastModifier: ViewModifier {
    
    @Binding var toast: Toast?
    @State var workItem: DispatchWorkItem?
    
    @ViewBuilder
    func mainToastView() -> some View {
        if let toast {
            VStack {
                Spacer()
                ToastView(message: toast.message)
            }
        }
    }
    
    func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now()+toast.duration, execute: task)
        }
    }
    
    func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                mainToastView()
            }
            .onChange(of: toast) { value in
                showToast()
            }
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

#Preview {
    ToastView(message: "반가워요")
}
