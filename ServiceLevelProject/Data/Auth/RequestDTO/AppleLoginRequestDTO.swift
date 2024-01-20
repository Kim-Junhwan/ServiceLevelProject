//
//  AppleLoginRequestDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/20.
//

import Foundation

struct AppleLoginRequestDTO: Encodable {
    let idToken: String
    let nickName: String?
    let deviceToken: String?
}
