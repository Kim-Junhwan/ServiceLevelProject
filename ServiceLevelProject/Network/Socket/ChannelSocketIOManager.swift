//
//  ChannelSocketIOManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/22.
//

import Combine
import Foundation

final class ChannelSocketIOManager: SocketIOManager<ChannelChattingResponseDTO> {
    var chattingSubject: PassthroughSubject<ChannelChatting, Error> = .init()
    
    init(id: Int) {
        super.init(id: id, type: .channel)
    }
    
    override func messageClosure(decodeData: ChannelChattingResponseDTO) {
        guard let messageDate = try? decodeData.toDomain() else { fatalError("DMMessage Date Parsing Error") }
        chattingSubject.send(messageDate)
    }
    
    func emit(chatting: ChannelChatting) {
        let user: UserThumbnailResponseDTO = .init(userId: chatting.user.id, email: chatting.user.email, nickname: chatting.user.nickname, profileImage: chatting.user.profileImagePath)
        super.sendMessage(chatting: .init(channelId: chatting.channelId, channelName: chatting.channelName, chatId: chatting.chatId, content: chatting.content, createdAt: chatting.channelName, files: chatting.files, user: user))
    }
}
