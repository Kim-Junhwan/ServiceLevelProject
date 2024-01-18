//
//  UserRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/09.
//

import Foundation

protocol AuthRepository {
    func checkValidateEmail(email: String) async throws
    func registerUser(_ query: RegisterUserRequestQuery) async throws -> RegistedUserProfile
}
