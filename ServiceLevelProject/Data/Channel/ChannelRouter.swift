//
//  ChannelRouter.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Foundation
import Alamofire

enum ChannelRouter: URLRequestConvertible {
    case fetchComeInChannel(Int)
    
    var method: HTTPMethod {
        switch self {
        case .fetchComeInChannel:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchComeInChannel(let workspaceId):
            return "/v1/workspaces/\(workspaceId)/channels/my"
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
