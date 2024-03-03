//
//  AuthRouter.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/12.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
    
    case checkValidEmail(ValidEmailRequestDTO)
    case registerUser(RegisterUserRequestDTO)
    case kakaoLogin(KakaoLoginRequestDTO)
    case appleLogin(AppleLoginRequestDTO)
    case emailLogin(EmailLoginRequestDTO)
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .checkValidEmail(_):
            return "/v1/users/validation/email"
        case .registerUser(_):
            return "/v1/users/join"
        case .kakaoLogin(_):
            return "/v1/users/login/kakao"
        case .appleLogin(_):
            return "/v1/users/login/apple"
        case .emailLogin(_):
            return "/v2/users/login"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: path) else { throw DefaultNetworkingError.failCreateURL }
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .checkValidEmail(let validEmailRequestDTO):
            request = try JSONParameterEncoder().encode(validEmailRequestDTO, into: request)
        case .registerUser(let registerUserRequestDTO):
            request = try JSONParameterEncoder().encode(registerUserRequestDTO, into: request)
        case .kakaoLogin(let kakaoLoginRequestDTO):
            request = try JSONParameterEncoder().encode(kakaoLoginRequestDTO, into: request)
        case .appleLogin(let appleLoginRequestDTO):
            request = try JSONParameterEncoder().encode(appleLoginRequestDTO, into: request)
        case .emailLogin(let emailLoginRequestDTO):
            request = try JSONParameterEncoder().encode(emailLoginRequestDTO, into: request)
        }
        return request
    }
}
