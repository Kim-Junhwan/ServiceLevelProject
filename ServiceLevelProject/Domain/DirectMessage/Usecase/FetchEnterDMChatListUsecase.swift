//
//  FetchEnterDMChatList.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

protocol FetchEnterDMChatListUsecase {
    func excute(workspaceId: Int, audienceId: Int) async throws -> DMChattingList
}

final class DefaultFetchEnterDMChatListUsecase {
    let chattingRepository: ChattingRepository
    let dmReposiotry: DirectMessageRepository
    
    init(chattingRepository: ChattingRepository, dmReposiotry: DirectMessageRepository) {
        self.chattingRepository = chattingRepository
        self.dmReposiotry = dmReposiotry
    }
}

extension DefaultFetchEnterDMChatListUsecase: FetchEnterDMChatListUsecase {
    func excute(workspaceId: Int, audienceId: Int) async throws -> DMChattingList {
        var fetchChattingList = await chattingRepository.fetchDMChatting(.init(workspaceId: workspaceId, audienceId: audienceId))
        let lastChattingDate = fetchChattingList.last?.createdAt
        let fetchChat = try await dmReposiotry.fetchDMChattingList(.init(audienceId: audienceId, workspaceId: workspaceId, cursorDate: lastChattingDate))
        try await chattingRepository.saveDMChatting(fetchChat)
        fetchChattingList.append(contentsOf: fetchChat.chats)
        return .init(workspaceId: fetchChat.workspaceId, roomId: fetchChat.roomId, chats: fetchChattingList)
    }
}
