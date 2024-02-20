//
//  ChattingCell.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/20.
//

import SwiftUI

struct ChannelCell: View {
    let title: String
    @Binding var newChatCount: Int
    
    var body: some View {
        ChatListDefaultcell(title: title, leftImage: {
            Image(systemName: "number")
                .resizable()
                .frame(width: 14.5, height: 14.5)
        }, newChatCount: newChatCount)
        .foregroundStyle(newChatCount != 0 ? .textPrimary : .textSecondary)
    }
}

struct DMCell: View {
    let title: String
    let userProfileUrl: String?
    @Binding var newChatCount: Int
    
    var body: some View {
        ChatListDefaultcell(title: title, leftImage: {
            FetchImageFromServerView(url: userProfileUrl) {
                Image(.noPhotoGreen)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
            }
            .frame(width: 24, height: 24)
            .clipShape(.rect(cornerRadius: 4))
        }, newChatCount: newChatCount)
        .foregroundStyle(.textSecondary)
    }
}

struct ChatListDefaultcell<IconImage: View>: View {
    let title: String
    let leftImage: () -> IconImage
    let newChatCount: Int
    
    var body: some View {
        HStack(spacing: 16) {
            leftImage()
                
            Text(title)
                .font(newChatCount != 0 ? CustomFont.bodyBold.font : CustomFont.body.font)
            Spacer()
            if newChatCount != 0 {
                newChatCounter
            }
        }
        .frame(height: 41)
        .padding([.leading, .trailing], 16)
    }
    
    @ViewBuilder
    var newChatCounter: some View {
        Text("\(newChatCount)")
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 2)
            .foregroundStyle(.white)
            .background(.brandGreen)
            .background(in: .capsule)
    }
}

#Preview {
    DMCell(title: "고양이", userProfileUrl: nil, newChatCount: .constant(0))
}
