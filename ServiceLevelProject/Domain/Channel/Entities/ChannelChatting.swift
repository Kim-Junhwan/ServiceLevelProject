//
//  ChannelChatting.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

struct ChannelChatting {
    let channelId: Int
    let channelName: String
    let chatId: Int
    let content: String?
    let createdAt: Date
    let files: [String]
    let user: UserThumbnail
}
