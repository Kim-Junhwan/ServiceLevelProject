//
//  ChatListSectionHeader.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/21.
//

import SwiftUI

struct ChatListSectionHeader: View {
    let title: String
    @Binding var isOpened: Bool
    var body: some View {
        Button {
            withAnimation {
                isOpened.toggle()
            }
        } label: {
            HStack {
                Text(title)
                    .font(CustomFont.title2.font)
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 9, height: 14)
                    .tint(.black)
                    .rotationEffect(.degrees(isOpened ? 90: 0))
                    .animation(.easeInOut(duration: 0.2), value: isOpened)
            }
            .padding(14)
            .frame(height: 56)
        }
    }
}

#Preview {
    ChatListSectionHeader(title: "채널", isOpened: .constant(true))
}
