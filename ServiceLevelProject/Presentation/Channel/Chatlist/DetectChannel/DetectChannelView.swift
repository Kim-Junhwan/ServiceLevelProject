//
//  DetectChannelView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/25.
//

import SwiftUI

struct DetectChannelView: View {
    @Binding var isPresenting: Bool
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(channelList) { channelItem in
                    channelListCell(title: channelItem.name)
                        .listRowInsets(.init())
                        .listRowSeparator(.hidden)
                }
                .foregroundStyle(.textPrimary)
            }
            .padding(.top, 8)
            .listStyle(.plain)
            .underlineNavigationBar(title: "채널 탐색")
            .toolbarBackground(.white, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresenting = false
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    })
                }
            }
        }
        .background(.secondary)
    }
    
    @ViewBuilder
    func channelListCell(title: String) -> some View {
        ChatListDefaultcell(title: title, leftImage: {
            Image(systemName: "number")
                .resizable()
                .frame(width: 14.5, height: 14.5)
        }, newChatCount: 0)
        .font(CustomFont.bodyBold.font)
        .foregroundStyle(.black)
    }
}

#Preview {
    DetectChannelView(isPresenting: .constant(true))
}
