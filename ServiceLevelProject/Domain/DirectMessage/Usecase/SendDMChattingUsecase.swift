//
//  SendDMChattingUsecase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

protocol SendDMChattingUsecase {
    func excute(roomId: Int, workspaceId: Int, content: String?, files: [Data]) async throws -> ChattingMessageModel
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
    func excute(roomId: Int, workspaceId: Int, content: String?, files: [Data]) async throws -> ChattingMessageModel {
        let sendChatting = try await dmRepository.postDMChatting(.init(roomId: roomId, workspaceId: workspaceId, content: content, files: files))
        try await chattingRepository.saveDMChatting(.init(workspaceId: workspaceId, roomId: roomId, chats: [sendChatting]))
        return .init(chatId: sendChatting.dmId, content: sendChatting.content, createdAt: sendChatting.createdAt, files: sendChatting.files, user: .init(userThumnail: sendChatting.user))
    }
}
