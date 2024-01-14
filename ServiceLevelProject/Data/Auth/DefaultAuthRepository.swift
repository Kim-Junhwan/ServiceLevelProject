//
//  DefaultAuthRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/09.
//

import Foundation
import Alamofire

final class DefaultAuthRepository: AuthRepository {
    func checkValidateEmail(email: String) async throws -> Bool {
        do {
            let _ = try await SSAC.request(AuthRouter.checkValidEmail(.init(email: email))).slpSerializingDecodable(Empty.self , emptyResponseCodes: [200], responseErrorMapper: ValidEmailErrorMapper()).value
        } catch {
            guard let originError = error.asAFError?.unwrap() else { throw DefaultNetworkingError.unknownResponseError }
            throw originError
        }
        return true
    }
}
