//
//  DMChattingObject.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation
import RealmSwift

class DMChattingObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var workspaceId: Int
    @Persisted var dmId: Int
    @Persisted var roomlId: Int
    @Persisted var content: String?
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
    @Persisted var user: UserObject?
    
    convenience init(workspaceId: Int, dmId: Int, roomId: Int, content: String?, createdAt: Date, files: [String], user: UserObject) {
        self.init()
        self.workspaceId = workspaceId
        self.dmId = dmId
        self.roomlId = roomId
        self.content = content
        self.createdAt = createdAt
        self.files.append(objectsIn: files)
        self.user = user
    }
    
    func toDomain() -> DMChatting {
        guard let domainUser = user?.toDomain() else { fatalError() }
        return .init(dmId: dmId, roomId: roomlId, content: content, createdAt: createdAt, files: files.map{$0}, user: domainUser)
    }
}
