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
    
    func registerUser(_ query: RegisterUserRequestQuery) async throws -> RegistedUserProfile {
        let requestDTO = RegisterUserRequestDTO(email: query.email, password: query.password, nickname: query.nickName, phone: query.password, deviceToken: query.deviceToken)
        do {
            let response = try await SSAC.request(AuthRouter.registerUser(requestDTO)).slpSerializingDecodable(RegisterUserResponseDTO.self, responseErrorMapper: RegisterUserErrorMapper()).value
            return .init(userId: response.userId, email: response.email, nickName: response.nickName, profileImage: response.profileImage, phone: response.phone, vendor: response.vendor, createdAt: response.createdAt, accessToken: response.token.accessToken, refreshToken: response.token.refreshToken)
        } catch {
            guard let originError = error.asAFError?.unwrap() else { throw DefaultNetworkingError.unknownResponseError }
            throw originError
        }
    }
}
