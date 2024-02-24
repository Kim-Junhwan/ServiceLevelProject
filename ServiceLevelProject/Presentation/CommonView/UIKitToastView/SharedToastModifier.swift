//
//  SharedToastModifier.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/24.
//

import Foundation
import SwiftUI

struct SharedToastModifier: ViewModifier {
    @Binding var toast: Toast?
    let bottomPadding: CGFloat
    
    func body(content: Content) -> some View {
        content
            .onChange(of: toast) { value in
                guard let message = toast?.message else { return }
                let toastView = SingleToastView(toast: $toast)
                toastView.show(message: message)
            }
    }
}

extension View {
    func singleToastView(toast: Binding<Toast?>, bottomPadding: CGFloat = 0) -> some View {
        self.modifier(SharedToastModifier(toast: toast, bottomPadding: bottomPadding))
    }
}
