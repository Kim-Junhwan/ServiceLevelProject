//
//  DMSocketIOManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/22.
//

import Foundation
import Combine

final class DMSocketIOManager: SocketIOManager<DMChattingResponseDTO> {
    
    var chattingSubject: PassthroughSubject<[DMChatting], Error> = .init()
    
    init(id: Int) {
        super.init(id: id, type: .dm)
    }
    
    override func messageClosure(decodeData: DMChattingResponseDTO) {
        guard let messageDate = try? decodeData.createdAt.toDate() else { fatalError("DMMessage Date Parsing Error") }
        chattingSubject.send([.init(dmId: decodeData.dmId, roomId: decodeData.roomId, content: decodeData.content, createdAt: messageDate, files: decodeData.files, user: decodeData.user.toDomain())])
    }
    
    func emit(chatting: DMChatting) {
        let user: UserThumbnailResponseDTO = .init(userId: chatting.user.id, email: chatting.user.email, nickname: chatting.user.nickname, profileImage: chatting.user.profileImagePath)
        super.sendMessage(chatting: .init(dmId: chatting.dmId, roomId: chatting.roomId, content: chatting.content, createdAt: chatting.createdAt.description, files: chatting.files, user: user))
    }
}
