//
//  KeyboardStickeyButton.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/07.
//

import SwiftUI

struct KeyboardStickeyButton: View {
    @Binding var isFocus: Bool
    var title: String
    @Binding var isEnable: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if $isFocus.wrappedValue {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.seperator)
            }
                
            RoundedButton(action: {
                action()
            }, label: {
                Text(title)
            }, backgroundColor: isEnable ? .brandGreen : .brandInactive)
            .padding([.top, .bottom], 12)
            .padding([.leading, .trailing], 24)
            .disabled(!isEnable)
        }
    }
}

