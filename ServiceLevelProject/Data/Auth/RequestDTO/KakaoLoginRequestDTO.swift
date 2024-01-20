//
//  KakaoLoginRequestDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/20.
//

import Foundation

struct KakaoLoginRequestDTO: Encodable {
    let oauthToken: String
    let deviceToken: String?
}
