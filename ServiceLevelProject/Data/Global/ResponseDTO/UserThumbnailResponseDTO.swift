//
//  UserThumbnailResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//

import Foundation

struct UserThumbnailResponseDTO: Decodable {
    let userId: Int
    let email: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
    }
    
    func toDomain() -> UserThumbnail {
        return .init(id: userId, email: email, nickname: nickname, profileImagePath: profileImage)
    }
}
