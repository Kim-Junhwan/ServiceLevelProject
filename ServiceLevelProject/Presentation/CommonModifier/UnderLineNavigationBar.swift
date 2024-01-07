//
//  UnderLineNavigationBar.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/07.
//

import Foundation
import SwiftUI

struct UnderLineNavigationBarModifier: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle(title)
    }
}

extension View {
    func underlineNavigationBar(title: String) -> some View {
        self.modifier(UnderLineNavigationBarModifier(title: title))
    }
}
