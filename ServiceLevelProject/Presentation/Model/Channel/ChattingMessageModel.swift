//
//  ChattingMessageModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

struct ChattingMessageModel: Identifiable {
    let id: UUID = .init()
    let chatId: Int
    let content: String?
    let createdAt: Date
    let files: [String]
    let user: UserThumbnailModel
}
