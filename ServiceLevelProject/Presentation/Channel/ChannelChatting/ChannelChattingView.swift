//
//  ChannelChattingView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import SwiftUI

struct ChannelChattingView: View {
    @StateObject var viewModel: ChannelChattingViewModel
    
    init(channelThumnailModel: ChannelListItemModel) {
        self._viewModel = StateObject(wrappedValue: SharedAssembler.shared.resolve(ChannelChattingViewModel.self, argument: channelThumnailModel))
    }
    
    var body: some View {
        ChattingView()
            .underlineNavigationBar(title: "")
            .toolbarBackground(.white, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 5) {
                        if let channel = viewModel.state.detailChannelInfo {
                            Text("#\(channel.name)")
                            Text("\(channel.channelMembers.count)")
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    .font(.system(size: 17, weight: .bold))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .fontWeight(.bold)
                            .frame(width: 18, height: 16)
                    })
                }
            }
            .onAppear {
                viewModel.trigger(.onAppear)
            }
    }
}

#Preview {
    ChannelChattingView(channelThumnailModel: .init(channelList: .init(workspaceId: 1, channelId: 1, name: "귀염둥이", description: "1234", ownerId: 1, secret: false, createdAt: Date())))
}
