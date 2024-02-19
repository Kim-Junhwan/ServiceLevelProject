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
        
        return .init(userId: value.userId, email: value.email, nickname: value.nickname, profileImage: value.profileImage, phone: value.phone, vendor: mappingVendor(vendorStr: value.vendor), sesacCoin: value.sesacCoin, createdAt: try value.createdAt.toDate())
    }
    
    func editProfile(_ query: EditProfileQuery) async throws -> UserProfile {
        let requestDTO = EditProfileRequestDTO(nickname: query.nickname, phone: query.phone)
        let value = try await SSAC.accessTokenRequest(ProfileRouter.editProfile(requestDTO)).slpSerializingDecodable(UserProfileResponseDTO.self, responseErrorMapper: EditProfileErrorMapper()).value
        return .init(userId: value.userId, email: value.email, nickname: value.nickname, profileImage: value.profileImage, phone: value.phone, vendor: mappingVendor(vendorStr: value.vendor), sesacCoin: value.sesacCoin, createdAt: try value.createdAt.toDate())
    }
    
    func editProfileImage(imageData: Data) async throws -> UserProfile {
        let value = try await SSAC.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, with: ProfileRouter.editProfileImage, interceptor: TokenInterceptor())
            .slpSerializingDecodable(UserProfileResponseDTO.self, responseErrorMapper: EditProfileImageErrorMapper()).value
        
        return .init(userId: value.userId, email: value.email, nickname: value.nickname, profileImage: value.profileImage, phone: value.phone, vendor: mappingVendor(vendorStr: value.vendor), sesacCoin: value.sesacCoin, createdAt: try value.createdAt.toDate())
    }
    
    private func mappingVendor(vendorStr: String?) -> LoginType {
        if let vendor = vendorStr {
            return .init(rawValue: vendor) ?? .email(email: "", password: "")
        } else {
            return .email(email: "", password: "")
        }
    }
}
