//
//  LoginType.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/15.
//

import Foundation

enum LoginType {
    case apple
    case kakao
    case email(email: String, password: String)
}
