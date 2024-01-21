//
//  RegisterUserResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/14.
//

import Foundation

struct UserInfoResponseDTO: Decodable {
    let userId: Int
    let email: String
    let nickName: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let createdAt: String
    let token: TokenResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickName = "nickname"
        case profileImage
        case phone
        case vendor
        case createdAt
        case token
    }
}

struct TokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
