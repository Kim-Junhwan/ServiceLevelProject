//
//  KeyboardStickeyButton.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/07.
//

import SwiftUI

struct KeyboardStickeyButton: View {
    
    var isFocus: FocusState<Bool>.Binding
    var title: String
    @Binding var isEnable: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if isFocus.wrappedValue {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.seperator)
            }
                
            RoundedButton(action: {
                
            }, label: {
                Text(title)
            }, backgroundColor: isEnable ? .brandGreen : .brandInactive)
            .padding([.top, .bottom], 12)
            .padding([.leading, .trailing], 24)
            .background(
                Color.backgroundPrimary
        )
        }
    }
}

