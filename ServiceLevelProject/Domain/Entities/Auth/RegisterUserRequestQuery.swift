//
//  RegisterUserRequestQuery.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/14.
//

import Foundation

struct RegisterUserRequestQuery {
    let email: String
    let password: String
    let nickName: String
    let phoneNumber: String?
    let deviceToken: String?
}
