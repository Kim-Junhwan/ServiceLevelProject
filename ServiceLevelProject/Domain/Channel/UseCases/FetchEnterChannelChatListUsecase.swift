//
//  FetchEnterChannelChatListUsecase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/22.
//

import Foundation

protocol FetchEnterChannelChatListUsecase {
    func excute(channelItem :ChannelListItemModel) async throws -> ([ChannelChatting], DetailChannelInfo)
}

final class DefaultFetchEnterChannelChatListUsecase {
    let chattingRepository: ChattingRepository
    let channelRepository: ChannelRepository
    
    init(chattingRepository: ChattingRepository, channelRepository: ChannelRepository) {
        self.chattingRepository = chattingRepository
        self.channelRepository = channelRepository
    }
}

extension DefaultFetchEnterChannelChatListUsecase: FetchEnterChannelChatListUsecase {
    func excute(channelItem :ChannelListItemModel) async throws -> ([ChannelChatting], DetailChannelInfo) {
        var dbChattingList = await chattingRepository.fetchChannelChatting(.init(channelId: channelItem.id))
        let lastChattingDate = dbChattingList.last?.createdAt
        let fetchChattingList = (try? await channelRepository.fetchChannelChatting(.init(workspaceId: channelItem.workspaceId, channelName: channelItem.name, cursorDate: lastChattingDate))) ?? []
        dbChattingList.append(contentsOf: fetchChattingList)
        try await chattingRepository.saveChannelChatting(fetchChattingList)
        let detailChannelInfo = try await channelRepository.fetchDetailChannel(.init(channelName: channelItem.name, workspaceId: channelItem.workspaceId))
        return (dbChattingList, detailChannelInfo)
    }
    
    
}
