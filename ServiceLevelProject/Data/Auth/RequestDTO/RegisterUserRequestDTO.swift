//
//  RegisterUserRequestDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/14.
//

import Foundation

struct RegisterUserRequestDTO: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String?
    let deviceToken: String?
}
