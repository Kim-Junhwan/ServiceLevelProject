//
//  EmailLoginQuery.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/21.
//

import Foundation

struct EmailLoginQuery {
    let email: String
    let password: String
    let deviceToken: String?
}

struct KakaoLoginQuery {
    let oauthToken: String
    let deviceToken: String?
}

struct AppleLoginQuery {
    let idToken: String
    let nickName: String?
    let deviceToken: String?
}
