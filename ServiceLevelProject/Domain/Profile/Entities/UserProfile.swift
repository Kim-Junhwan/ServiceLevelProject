//
//  UserProfile.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/18.
//

import Foundation

struct UserProfile {
    let userId: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: LoginType
    let sesacCoin: Int
    let createdAt: Date
}
