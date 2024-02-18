//
//  UserProfileResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/18.
//

import Foundation

struct UserProfileResponseDTO: Decodable {
    let userId: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let sesacCoin: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
        case vendor
        case phone
        case sesacCoin
        case createdAt
    }
}
