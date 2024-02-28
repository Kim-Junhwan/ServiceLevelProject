//
//  RealmChattingRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation
import RealmSwift

@MainActor
final class RealmChattingRepository {
    private let realm: Realm
    
    nonisolated init(realm: Realm) {
        self.realm = realm
    }
}

extension RealmChattingRepository: ChattingRepository {
    func saveChannelChatting(_ channelChatting: ChannelChatting) throws {
        let userObject = UserObject(userId: channelChatting.user.id, email: channelChatting.user.email, nickname: channelChatting.user.email, profileImage: channelChatting.user.profileImagePath)
        let chattingObject = ChannelChattingObject(chatId: channelChatting.chatId, channelId: channelChatting.channelId, channelName: channelChatting.channelName, content: channelChatting.content, createdAt: channelChatting.createdAt, files: channelChatting.files, user: userObject)
        try realm.write {
            realm.add(chattingObject)
        }
    }
    
    func fetchChannelChatting(_ query: FetchChannelChattingQuery) -> [ChannelChatting] {
        let channelChattingList = realm.objects(ChannelChattingObject.self).where { $0.channelId == query.channelId }
        return channelChattingList.map{ $0.toDomain() }
    }
}
