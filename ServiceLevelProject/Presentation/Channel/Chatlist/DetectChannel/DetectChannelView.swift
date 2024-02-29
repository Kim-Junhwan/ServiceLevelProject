//
//  DetectChannelView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/25.
//

import SwiftUI

struct DetectChannelView: View {
    @Binding var isPresenting: Bool
    @StateObject var viewModel: DetectChannelViewModel = SharedAssembler.shared.resolve(DetectChannelViewModel.self)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.state.channelList) { channelItem in
                    Button(action: {
                        viewModel.trigger(.tapChannel(channelItem))
                    }, label: {
                        channelListCell(title: channelItem.name)
                    })
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
            .customAlert(alertMessage: $viewModel.state.alertEnterChannel)
            .navigationDestination(isPresented: .constant(viewModel.state.selectChannel != nil)) {
                if let selectChannel = viewModel.state.selectChannel {
                    ChannelChattingView(channelThumnailModel: selectChannel)
                }
            }
        }
        .accentColor(.black)
        .background(.secondary)
        .onAppear {
            viewModel.trigger(.appearView)
        }
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
