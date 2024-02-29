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
    func saveChannelChatting(_ channelChatting: [ChannelChatting]) throws {
        let chattingObject = channelChatting.map { ChannelChattingObject(chatId: $0.chatId, channelId: $0.channelId, channelName: $0.channelName, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: .init(userId: $0.user.id, email: $0.user.email, nickname: $0.user.nickname, profileImage: $0.user.profileImagePath)) }
        try realm.write {
            realm.add(chattingObject)
        }
    }
    
    func fetchChannelChatting(_ query: FetchChannelChattingQuery) -> [ChannelChatting] {
        let channelChattingList = realm.objects(ChannelChattingObject.self).where { $0.channelId == query.channelId }
        return channelChattingList.map{ $0.toDomain() }
    }
}
