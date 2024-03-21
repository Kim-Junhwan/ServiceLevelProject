//
//  SendChattingUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

protocol SendChattingUseCase {
    func excute(channelName: String, workspaceId: Int, content: String, files: [Data]) async throws -> ChannelChatting
}

final class DefaultSendChattingUseCase {
    let channelRepository: ChannelRepository
    let chattingRepository: ChattingRepository
    
    init(channelRepository: ChannelRepository, chattingRepository: ChattingRepository) {
        self.channelRepository = channelRepository
        self.chattingRepository = chattingRepository
    }
}

extension DefaultSendChattingUseCase: SendChattingUseCase {
    func excute(channelName: String, workspaceId: Int, content: String, files: [Data]) async throws -> ChannelChatting {
        let postChat = try await channelRepository.postChatting(.init(name: channelName, workspaceId: workspaceId, content: content, files: files))
        try await chattingRepository.saveChannelChatting([postChat])
        return postChat
    }
}
