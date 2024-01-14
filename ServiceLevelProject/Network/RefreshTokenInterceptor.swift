//
//  RefreshTokenInterceptor.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/13.
//

import Foundation
import Alamofire

struct RefreshTokenInterceptor: RequestInterceptor {
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let afError = error.asAFError {
            if case let .responseValidationFailed(reason) = afError {
                if case let .customValidationFailed(slpError) = reason {
                    if let splpError = slpError as? SLPCommonError {
                        if splpError == .accessTokenTimeOut {
                            print("AccesstokenTimeOut")
                        }
                    }
                }
            }
        }
        //print(error.localizedDescription)
        completion(.doNotRetryWithError(error))
    }
}

extension AFError {
    func unwrap() -> Error {
        var error = self
        while true {
            guard let underlyingError = error.underlyingError else { return error }
            if let under = underlyingError.asAFError {
                error = under
            } else {
                return underlyingError
            }
        }
    }
}
