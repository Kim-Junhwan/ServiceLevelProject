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
    
    var method: HTTPMethod {
        switch self {
        case .checkValidEmail(_), .registerUser(_):
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .checkValidEmail(_):
            return "v1/users/validation/email"
        case .registerUser(_):
            return "v1/users/join"
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
        }
        return request
    }
}
