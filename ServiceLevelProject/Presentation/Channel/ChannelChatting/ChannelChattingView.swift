//
//  ChannelChattingView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import SwiftUI

struct ChannelChattingView: View {
    @StateObject var viewModel: ChannelChattingViewModel
    @State var showChannelOption: Bool = false
    
    init(channelThumnailModel: ChannelListItemModel) {
        self._viewModel = StateObject(wrappedValue: SharedAssembler.shared.resolve(ChannelChattingViewModel.self, argument: channelThumnailModel))
    }
    
    var body: some View {
        ChattingView(inputText: $viewModel.state.chattingBarText, chatList: viewModel.state.chattingList, imagePickerModel: viewModel.imageModel, sendSuccess: $viewModel.state.successSend, sendButtonAction: {
            viewModel.trigger(.sendChatting)
        })
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
                    showChannelOption = true
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
        .onDisappear {
            viewModel.trigger(.dismissView)
        }
        .navigationDestination(isPresented: $showChannelOption) {
            if let channelInfo = viewModel.state.detailChannelInfo {
                ChannelOptionView(memberList: channelInfo.channelMembers, channelName: channelInfo.name)
            }
            
        }
    }
}
