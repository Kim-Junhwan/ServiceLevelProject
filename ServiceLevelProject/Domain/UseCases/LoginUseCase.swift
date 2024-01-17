//
//  SocialLoginUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/06.
//

import Foundation

enum LoginPlatform {
    case kakao
    case apple(idToken: String, nickName: String)
    case email(email: String, password: String)
}

protocol LoginUseCase {
    func excute(_ platform: LoginType) async throws -> Bool
}
