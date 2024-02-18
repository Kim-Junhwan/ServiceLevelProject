//
//  ProfileRouter.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/18.
//

import Alamofire
import Foundation

enum ProfileRouter: URLRequestConvertible {
    case fetchMyProfile
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyProfile:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyProfile:
            return "/v1/users/my"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw DefaultNetworkingError.failCreateURL
        }
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        default:
            break
        }
        return request
    }
}
