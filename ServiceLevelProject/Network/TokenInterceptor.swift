//
//  RefreshTokenInterceptor.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/13.
//

import Foundation
import Alamofire

enum TokenError: Error {
    case missingAccessToken
    case missingRefreshToken
}

struct TokenInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        guard let accessToken = Token.accessToken else {
            completion(.failure(TokenError.missingAccessToken))
            return
        }
        urlRequest.headers.add(.authorization(accessToken))
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let afError = error.asAFError {
            if let slpError = afError.unwrap() as? SLPCommonError {
                if case .accessTokenTimeOut = slpError {
                    AccessTokenRefresher().excute(refreshToken: Token.refreshToken) { result in
                        switch result {
                        case .success(let success):
                            Token.accessToken = success
                            completion(.retry)
                        case .failure(let failure):
                            completion(.doNotRetryWithError(failure))
                        }
                    }
                }
            }
        }
    }
}

fileprivate struct AccessTokenRefresher {
    func excute(refreshToken: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let refreshToken else {
            completion(.failure(TokenError.missingRefreshToken))
            return
        }
        let header: HTTPHeaders = ["RefreshToken":refreshToken]
        SSAC.request("v1/auth/refresh", headers: header).slpResponseDecodable(of: RefreshTokenResponseDTO.self) { response in
            switch response.result {
            case .success(let dto):
                completion(.success(dto.accessToken))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
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
