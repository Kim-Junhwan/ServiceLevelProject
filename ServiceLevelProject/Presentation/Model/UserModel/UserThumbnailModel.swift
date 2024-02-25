//
//  UserThumbnailModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/25.
//

import Foundation

struct UserThumbnailModel: Hashable {
    let id: Int
    let email: String
    let nickname: String
    let profileImagePath: String?
    
    init(userThumnail: UserThumbnail) {
        id = userThumnail.id
        email = userThumnail.email
        nickname = userThumnail.nickname
        profileImagePath = userThumnail.profileImagePath
    }
}
