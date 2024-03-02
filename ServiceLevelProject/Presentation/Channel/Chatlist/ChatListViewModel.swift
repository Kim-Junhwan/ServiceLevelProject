//
//  ChatListViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Combine
import Foundation

final class ChatListViewModel: ViewModel, ObservableObject {
    enum ChatListViewModelInput {
        case createChannel(name: String, description: String?)
    }
    
    struct ChatListViewState {
        var channelList: [ChannelListItemModel] = []
        var dmList: [DMRoomItemModel] = []
        var toast: Toast?
        var successCreateChannel: Bool = false
    }
    
    @Published var state: ChatListViewState = .init()
    private let fetchWorkspaceChatListUsecase: FetchWorkspaceComeInChannelDMListUseCase
    private let createChannelUsecase: CreateChannelUseCase
    private var cancellableBag = Set<AnyCancellable>()
    private let appState: AppState
    
    init(fetchWorkspaceChatUsecase: FetchWorkspaceComeInChannelDMListUseCase, createChannelUsecase: CreateChannelUseCase, appState: AppState) {
        self.fetchWorkspaceChatListUsecase = fetchWorkspaceChatUsecase
        self.createChannelUsecase = createChannelUsecase
        self.appState = appState
        appStateBind()
    }
    
    private func appStateBind() {
        appState.$selectWorkspace
            .sink { selectWorkspace in
                self.fetchSelectWorkspaceChatList(workspaceId: selectWorkspace?.workspaceId)
            }
            .store(in: &cancellableBag)
    }
    
    func trigger(_ input: ChatListViewModelInput) {
        switch input {
        case .createChannel(let name, let description):
            createChannel(name: name, description: description)
        }
    }
    
    private func fetchSelectWorkspaceChatList(workspaceId: Int?) {
        guard let workspaceId else { return }
        Task {
            let fetchChatList = try await fetchWorkspaceChatListUsecase.excute(workspaceId: workspaceId)
            DispatchQueue.main.async {
                self.state.channelList = fetchChatList.comeInChannelList.map{ .init(channelList: $0) }
                self.state.dmList = fetchChatList.dmList.map{ .init(dm: $0, thumbnailContent: "", newMessageCount: 0) }
            }
        }
    }
    
    private func createChannel(name: String, description: String?) {
        guard let workspaceId = appState.selectWorkspace?.workspaceId else { return }
        Task {
            do {
                state.channelList = try await createChannelUsecase.excute(workspaceId: workspaceId, channelName: name, channelDescription: description).map{ .init(channelList: $0) }
                state.successCreateChannel = true
            }
        }
    }
    
}
