//
//  ChatListView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct ChatListView: View {
    
    @StateObject var viewModel: ChatListViewModel = SharedAssembler.shared.resolve(ChatListViewModel.self)
    @State private var showCreateChannel = false
    @State private var showDetectChannel = false
    @State private var openChannelList = false
    @State private var openDMList = false
    @State private var showChannelActionSheet: Bool = false
    @State private var showInviteMember = false
    @State private var showChannelChatting = false
    @State private var selectedChannel: ChannelListItemModel?
    @State private var showDMChattingView = false
    @State private var selectDMUser: UserThumbnailModel?
    
    var body: some View {
        ZStack {
            VStack {
                ChannelListTableView(directMessage: $viewModel.state.dmList, channelList: $viewModel.state.channelList, showChannelActionSheet: $showChannelActionSheet, channelOpen: $openChannelList, showInviteMember: $showInviteMember, dmOpen: $openDMList) { channel in
                    selectedChannel = channel
                    showChannelChatting = true
                } dmCellSelect: { dm in
                    selectDMUser = dm.user
                    showDMChattingView = true
                }

            }
            floatingButtonView
        }
        .navigationDestination(isPresented: $showChannelChatting, destination: {
            if let selectedChannel {
                ChannelChattingView(channelThumnailModel: selectedChannel)
            }
        })
        .navigationDestination(isPresented: $showDMChattingView, destination: {
            if let selectDMUser {
                DMChattingView(selectUser: selectDMUser)
            }
        })
        .sheet(isPresented: $showCreateChannel, content: {
            CreateChannelView(isPresenting: $showCreateChannel, viewModel: viewModel)
        })
        .sheet(isPresented: $showInviteMember, content: {
            InviteMemberView(isPresenting: $showInviteMember)
        })
        .fullScreenCover(isPresented: $showDetectChannel, content: {
            DetectChannelView(isPresenting: $showDetectChannel)
        })
        .confirmationDialog("", isPresented: $showChannelActionSheet) {
            channelActionSheet
        }
        
    }
    
    @ViewBuilder
    var floatingButtonView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                floatingButton
                    .offset(x: -16, y: -16)
            }
        }
    }
    
    @ViewBuilder
    var floatingButton: some View {
        Button {
            
        } label: {
            Circle()
                .fill(.brandGreen)
                .overlay {
                    Image(.writeMessage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 17, height: 17)
                }
                .frame(width: 50, height: 50)
                .shadow(radius: 7, y: 4)
        }
        
    }
    
    @ViewBuilder
    var channelActionSheet: some View {
        VStack {
            Button("채널 생성") {
                showCreateChannel = true
            }
            Button("채널 탐색") {
                showDetectChannel = true
            }
            Button("취소", role: .cancel) {}
        }
    }
}

//#Preview {
//    ChatListView()
//}
