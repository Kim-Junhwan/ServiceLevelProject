//
//  SendDMChattingUsecase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

protocol SendDMChattingUsecase {
    func excute(roomId: Int, workspaceId: Int, content: String?, files: [Data]) async throws -> DMChatting
    func saveChatting(roomId: Int, workspaceId: Int, chatting: [DMChatting]) async throws
}

final class DefaultSendDMChattingUsecase {
    let chattingRepository: ChattingRepository
    let dmRepository: DirectMessageRepository
    
    init(chattingRepository: ChattingRepository, dmRepository: DirectMessageRepository) {
        self.chattingRepository = chattingRepository
        self.dmRepository = dmRepository
    }
}

extension DefaultSendDMChattingUsecase: SendDMChattingUsecase {
    func saveChatting(roomId: Int, workspaceId: Int, chatting: [DMChatting]) async throws {
        try await chattingRepository.saveDMChatting(.init(workspaceId: workspaceId, roomId: roomId, chats: chatting))
    }
    
    func excute(roomId: Int, workspaceId: Int, content: String?, files: [Data]) async throws -> DMChatting {
        let sendChatting = try await dmRepository.postDMChatting(.init(roomId: roomId, workspaceId: workspaceId, content: content, files: files))
        try await chattingRepository.saveDMChatting(.init(workspaceId: workspaceId, roomId: roomId, chats: [sendChatting]))
        return sendChatting
    }
}
