//
//  ChatListView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct Channel: Identifiable {
    let id: Int
    let title: String
    let newMessageCount: Int
}

struct DirectMessage {
    let profileImage: String?
    let nickname: String
    let newMessageCount: Int
}

struct ChatListView: View {
    
    @StateObject var viewModel: ChatListViewModel = SharedAssembler.shared.resolve(ChatListViewModel.self)
    @State private var showCreateChannel = false
    @State private var openChannelList = false
    @State private var openDMList = false
    
    var body: some View {
        ZStack {
            VStack {
                ChannelListTableView(directMessage: $viewModel.state.dmList, channelList: $viewModel.state.channelList, showCreateChannel: $showCreateChannel, channelOpen: $openChannelList, dmOpen: $openDMList)
            }
            floatingButtonView
        }
        .sheet(isPresented: $showCreateChannel, content: {
            CreateChannelView(isPresenting: $showCreateChannel, viewModel: viewModel)
        })
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
}

#Preview {
    ChatListView()
}
