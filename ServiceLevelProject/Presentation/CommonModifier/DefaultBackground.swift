//
//  DefaultBackground.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/07.
//

import Foundation
import SwiftUI

struct DefaultBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
    }
}

extension View {
    func defaultBackground() -> some View {
        self.modifier(DefaultBackgroundModifier())
    }
}
