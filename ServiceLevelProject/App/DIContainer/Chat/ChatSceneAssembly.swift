//
//  ChatSceneAssembly.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/16.
//

import Swinject

class ChatSceneAssembly: Assembly {
    func assemble(container: Container) {
        let appState = container.resolve(AppState.self)!
        container.register(HomeViewModel.self) { resolver in
            let selectUsecase = resolver.resolve(SelectWorkspaceUseCase.self)!
            return HomeViewModel(appState: appState, selectWorkspaceUseCase: selectUsecase)
        }
        
        container.register(ChatListViewModel.self) { resolver in
            let fetchChatListUsecase = resolver.resolve(FetchWorkspaceComeInChannelDMListUseCase.self)!
            let createChannelUsecase = resolver.resolve(CreateChannelUseCase.self)!
            return ChatListViewModel(fetchWorkspaceChatUsecase: fetchChatListUsecase, createChannelUsecase: createChannelUsecase, appState: appState)
        }
        
        container.register(DetectChannelViewModel.self) { resolver in
            let channelRepository = resolver.resolve(ChannelRepository.self)!
            return DetectChannelViewModel(appState: appState, channelRepository: channelRepository)
        }
        
        container.register(ChannelChattingViewModel.self) { resolver, channelThumbnail in
            let channelRepository = resolver.resolve(ChannelRepository.self)!
            return ChannelChattingViewModel(appState: appState, channelThumbnail: channelThumbnail, channelRepository: channelRepository)
        }
    }
}
