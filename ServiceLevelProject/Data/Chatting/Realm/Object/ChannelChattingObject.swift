//
//  ChannelChattingObject.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation
import RealmSwift

class ChannelChattingObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var chatId: Int
    @Persisted var channelId: Int
    @Persisted var channelName: String
    @Persisted var content: String?
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
    @Persisted var user: UserObject?
    
    convenience init(chatId: Int, channelId: Int, channelName: String, content: String?, createdAt: Date, files: [String], user: UserObject) {
        self.init()
        self.chatId = chatId
        self.channelId = channelId
        self.channelName = channelName
        self.content = content
        self.createdAt = createdAt
        self.files.append(objectsIn: files)
        self.user = user
    }
    
    func toDomain() -> ChannelChatting {
        guard let domainUser = user?.toDomain() else { fatalError() }
        return .init(channelId: channelId, channelName: channelName, chatId: channelId, content: content, createdAt: createdAt, files: files.map{ $0 }, user: domainUser)
    }
}
