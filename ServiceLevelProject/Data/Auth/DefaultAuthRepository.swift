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
        let _ = try await SSAC.request(AuthRouter.checkValidEmail(.init(email: email))).serializingData(emptyResponseCodes: [200]).value
        return true
    }
    
}
