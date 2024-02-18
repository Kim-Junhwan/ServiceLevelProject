//
//  DefaultProfileRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/18.
//

import Alamofire
import Foundation

final class DefaultProfileRepository: ProfileRepository {
    func fetchMyProfile() async throws -> UserProfile {
        let value = try await SSAC.accessTokenRequest(ProfileRouter.fetchMyProfile).slpSerializingDecodable(UserProfileResponseDTO.self).value
        let loginType: LoginType
        if let vendor = value.vendor {
            loginType = .init(rawValue: vendor) ?? .email(email: "", password: "")
        } else {
            loginType = .email(email: "", password: "")
        }
        return .init(userId: value.userId, email: value.email, nickname: value.nickname, profileImage: value.profileImage, phone: value.phone, vendor: loginType, sesacCoin: value.sesacCoin, createdAt: try value.createdAt.toDate())
    }
    
    
}
