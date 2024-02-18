//
//  ProfileRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/18.
//

import Foundation

protocol ProfileRepository {
    func fetchMyProfile() async throws -> UserProfile
}
