//
//  GreenButton.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/02.
//

import SwiftUI

struct RoundedButton<Label: View>: View {
    
    let action: () -> Void
    let label: () -> Label
    var backgroundColor: Color
    
    var body: some View {
        Button(action: action) {
            label()
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 16)
                .foregroundStyle(.white)
                .background(backgroundColor)
                .frame(height: 44)
                .clipShape(.rect(cornerRadius: 8))
                .font(CustomFont.title2.font)
        }
    }
}

#Preview {
    RoundedButton(action: {
        
    }, label: {
        Text("123")
    }, backgroundColor: .brandGreen)

}
