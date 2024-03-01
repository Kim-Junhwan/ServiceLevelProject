//
//  DMChatting.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct DMChattingList {
    let workspaceId: Int
    let roomId: Int
    let chats: [DMChatting]
}

struct DMChatting {
    let dmId: Int
    let roomId: Int
    let content: String?
    let createdAt: Date
    let files: [String]
    let user: UserThumbnail
}
