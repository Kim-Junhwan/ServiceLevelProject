//
//  DefaultAuthRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/09.
//

import Foundation
import Alamofire

final class DefaultAuthRepository: AuthRepository {
    
    func checkValidateEmail(email: String) async throws {
        do {
            try await SSAC.request(AuthRouter.checkValidEmail(.init(email: email))).slpSerializingDecodable(Empty.self , emptyResponseCodes: [200], responseErrorMapper: ValidEmailErrorMapper()).value
        } catch {
            guard let originError = error.asAFError?.unwrap() else { throw DefaultNetworkingError.unknownResponseError }
            throw originError
        }
    }
    
    func registerUser(_ query: RegisterUserRequestQuery) async throws -> UserProfile {
        let requestDTO = RegisterUserRequestDTO(email: query.email, password: query.password, nickname: query.nickName, phone: query.password, deviceToken: query.deviceToken)
        do {
            let response = try await SSAC.request(AuthRouter.registerUser(requestDTO)).slpSerializingDecodable(UserInfoResponseDTO.self, responseErrorMapper: RegisterUserErrorMapper()).value
            return .init(userId: response.userId, email: response.email, nickName: response.nickName, profileImage: response.profileImage, phone: response.phone, vendor: response.vendor, createdAt: response.createdAt, accessToken: response.token.accessToken, refreshToken: response.token.refreshToken)
        } catch {
            guard let originError = error.asAFError?.unwrap() else { throw DefaultNetworkingError.unknownResponseError }
            throw originError
        }
    }
    
    func kakaoLogin(_ query: KakaoLoginQuery) async throws -> UserProfile {
        return try await login(urlRequest: AuthRouter.kakaoLogin(.init(oauthToken: query.oauthToken, deviceToken: query.deviceToken)))
    }
    
    func appleLogin(_ query: AppleLoginQuery) async throws -> UserProfile {
        return try await login(urlRequest: AuthRouter.appleLogin(.init(idToken: query.idToken, nickName: query.nickName, deviceToken: query.deviceToken)))
    }
    
    func emailLogin(_ query: EmailLoginQuery) async throws -> UserProfile {
        return try await login(urlRequest: AuthRouter.emailLogin(.init(email: query.email, password: query.password, deviceToken: query.deviceToken)))
    }
    
    private func login(urlRequest: URLRequestConvertible) async throws -> UserProfile {
        do {
            let response = try await SSAC.request(urlRequest).slpSerializingDecodable(UserInfoResponseDTO.self, responseErrorMapper: LoginErrorMapper()).value
            return .init(userId: response.userId, email: response.email, nickName: response.nickName, profileImage: response.profileImage, phone: response.phone, vendor: response.vendor, createdAt: response.createdAt, accessToken: response.token.accessToken, refreshToken: response.token.refreshToken)
        } catch {
            guard let originError = error.asAFError?.unwrap() else { throw DefaultNetworkingError.unknownResponseError }
            print(originError)
            throw originError
        }
    }
}
