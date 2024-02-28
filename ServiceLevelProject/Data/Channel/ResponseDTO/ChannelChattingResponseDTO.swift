//
//  ChannelChattingResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

struct ChannelChattingResponseDTO: Decodable {
    let channelId: Int
    let channelName: String
    let chatId: Int
    let content: String?
    let createdAt: String
    let files: [String]
    let user: UserThumbnailResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case channelName
        case chatId = "chat_id"
        case content
        case createdAt
        case files
        case user
    }
    
    func toDomain() throws -> ChannelChatting {
        return .init(channelId: channelId, channelName: channelName, chatId: chatId, content: content, createdAt: try createdAt.toDate(), files: files, user: user.toDomain())
    }
}
