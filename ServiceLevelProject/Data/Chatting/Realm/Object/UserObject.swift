//
//  UserObject.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation
import RealmSwift

class UserObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var userId: Int
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(userId: Int, email: String, nickname: String, profileImage: String?) {
        self.init()
        self.userId = userId
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
    
    func toDomain() -> UserThumbnail {
        return .init(id: userId, email: email, nickname: nickname, profileImagePath: profileImage)
    }
}
