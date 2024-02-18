//
//  UserRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/09.
//

import Foundation

protocol AuthRepository {
    func checkValidateEmail(email: String) async throws
    func registerUser(_ query: RegisterUserRequestQuery) async throws -> RegistUserProfile
    func kakaoLogin(_ query: KakaoLoginQuery) async throws -> RegistUserProfile
    func appleLogin(_ query: AppleLoginQuery) async throws -> RegistUserProfile
    func emailLogin(_ query: EmailLoginQuery) async throws -> RegistUserProfile
}
