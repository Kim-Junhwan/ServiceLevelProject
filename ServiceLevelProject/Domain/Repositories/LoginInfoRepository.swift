//
//  LogininfoRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/14.
//

import Foundation

protocol LoginInfoRepository: AnyObject {
    var loginType: LoginType { get set }
    var isLoggedIn: Bool { get set }
    func saveToken(accessToken: String, refreshToken: String?) throws
}
