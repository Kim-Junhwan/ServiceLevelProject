//
//  SocialLoginUseCase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/06.
//

import Foundation

enum LoginPlatform {
    case kakao
    case apple
    case email(email: String, password: String)
}

protocol LoginUseCase {
    func excute(_ platform: LoginPlatform) async throws -> Bool
}
