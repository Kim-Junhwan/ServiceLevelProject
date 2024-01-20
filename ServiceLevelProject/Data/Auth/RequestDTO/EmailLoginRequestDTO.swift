//
//  EmailLoginRequestDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/20.
//

import Foundation

struct EmailLoginRequestDTO: Encodable {
    let email: String
    let password: String
    let deviceToken: String?
}
