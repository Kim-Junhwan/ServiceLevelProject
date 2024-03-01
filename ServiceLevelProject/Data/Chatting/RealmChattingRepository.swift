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
    
    func saveDMChatting(_ dmChatting: DMChattingList) throws {
        let dmChattingObjectList = dmChatting.chats.map { DMChattingObject(workspaceId: dmChatting.workspaceId, dmId: $0.dmId, roomId: $0.roomId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: .init(userId: $0.user.id, email: $0.user.email, nickname: $0.user.nickname, profileImage: $0.user.profileImagePath)) }
        try realm.write {
            realm.add(dmChattingObjectList)
        }
    }
    
    func fetchDMChatting(_ query: FetchDMChattingQuery) -> [DMChatting] {
        let dmChattingList = realm.objects(DMChattingObject.self).where { $0.workspaceId == query.workspaceId && $0.user.userId == query.audienceId }
        return dmChattingList.map { $0.toDomain() }
    }
}
